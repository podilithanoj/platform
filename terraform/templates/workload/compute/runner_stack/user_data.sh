#!/bin/bash

# --- Variables injected by Terraform ---
region="${region}"
secret_name="${secret_name}"
runner_version="${runner_version}"
github_repo="${github_repo}"


# --- Install base dependencies ---
apt-get update -y
apt-get install -y git curl jq unzip software-properties-common zip

# --- Install AWS CLI v2 ---
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Ensure AWS CLI is in the path
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/aws-cli/v2/current/bin
aws --version

# --- Install Java and Maven (Optional) ---
add-apt-repository -y ppa:openjdk-r/ppa
apt-get update -y
apt-get install -y openjdk-17-jdk maven
java -version
mvn -version

# --- Fetch GitHub Runner Token securely from AWS Secrets Manager ---
raw_secret=$(aws secretsmanager get-secret-value \
  --region "$region" \
  --secret-id "$secret_name" \
  --query SecretString \
  --output text)

# Parse the github_token from JSON string
github_token=$(echo "$raw_secret" | jq -r '.github_token')
echo "DEBUG: github_token=$github_token" >> /var/log/github-token.log

# --- Setup GitHub Actions Runner ---
mkdir -p /actions-runner
cd /actions-runner

# --- Download and Extract GitHub Runner binary ---
curl -O -L "https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-linux-x64-${runner_version}.tar.gz"
tar xzf "actions-runner-linux-x64-${runner_version}.tar.gz"

# --- Install runner dependencies ---
./bin/installdependencies.sh

# --- Set correct permissions ---
chown -R ubuntu:ubuntu /actions-runner

# --- Configure the runner ---
su - ubuntu -c "/actions-runner/config.sh \
  --url https://github.com/${github_repo} \
  --token "$github_token" \
  --unattended \
  --labels terraform-runner" >> /var/log/github-runner-config.log 2>&1

# --- Create a systemd service for GitHub Actions Runner ---
sudo tee /etc/systemd/system/actions.runner.service > /dev/null <<EOF
[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
ExecStart=/actions-runner/run.sh
WorkingDirectory=/actions-runner
User=ubuntu
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# --- Enable and start the runner service ---
sudo systemctl daemon-reload
sudo systemctl enable actions.runner
sudo systemctl start actions.runner


