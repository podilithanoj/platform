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
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin
aws --version

# --- Install Java and Maven (Optional) ---
add-apt-repository -y ppa:openjdk-r/ppa
apt-get update -y
apt-get install -y openjdk-17-jdk maven
java -version
mvn -version

# --- Install JFrog CLI (Optional) ---
curl -fL https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/jfrog-cli-linux-amd64/ -o jfrog
chmod +x jfrog
mv jfrog /usr/local/bin/
jfrog --version

# --- Fetch GitHub Runner Token securely from AWS Secrets Manager ---
github_token=$(aws secretsmanager get-secret-value \
  --region "$region" \
  --secret-id "$secret_name" \
  --query SecretString \
  --output text)

# --- Setup GitHub Actions Runner ---
mkdir -p /actions-runner
cd /actions-runner

# --- Download and Extract GitHub Runner binary ---
curl -O -L "https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-linux-x64-${runner_version}.tar.gz"
tar xzf "actions-runner-linux-x64-${runner_version}.tar.gz"

# --- Install runner dependencies ---
./bin/installdependencies.sh

# --- Configure the runner (✅ Proper escaping for bash runtime variable) ---
./config.sh --url "https://github.com/${github_repo}" \
            --token "$${github_token}" \
            --unattended \
            --labels terraform-runner

# --- Correct folder permissions for 'ubuntu' user ---
chown -R ubuntu:ubuntu /actions-runner

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
