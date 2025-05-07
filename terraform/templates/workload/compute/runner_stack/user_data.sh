#!/bin/bash

# --- Variables injected by Terraform ---
region="${region}"
secret_name="${secret_name}"
runner_version="${runner_version}"
github_repo="${github_repo}"
runner_label="${runner_label}" 

# --- Install base dependencies ---
apt-get update -y
apt-get install -y git curl jq unzip software-properties-common zip

# --- Install AWS CLI v2 ---
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/aws-cli/v2/current/bin
aws --version

# --- Install Java and Maven ---
add-apt-repository -y ppa:openjdk-r/ppa
apt-get update -y
apt-get install -y openjdk-17-jdk maven
java -version
mvn -version

# --- Fetch GitHub PAT from AWS Secrets Manager ---
raw_secret=$(aws secretsmanager get-secret-value \
  --region "$region" \
  --secret-id "$secret_name" \
  --query SecretString \
  --output text)

github_pat=$(echo "$raw_secret" | jq -r '.github_pat')

# --- Generate GitHub registration token using the PAT ---
github_token=$(curl -s -X POST \
  -H "Authorization: token $github_pat" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/${github_repo}/actions/runners/registration-token" \
  | jq -r .token)

echo "GitHub registration token fetched successfully" >> /var/log/github-runner.log

# --- Set up the runner directory ---
mkdir -p /actions-runner
cd /actions-runner

curl -O -L "https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-linux-x64-${runner_version}.tar.gz"
tar xzf "actions-runner-linux-x64-${runner_version}.tar.gz"

./bin/installdependencies.sh
chown -R ubuntu:ubuntu /actions-runner

# --- Register the runner (as ubuntu) ---
su - ubuntu -c "/actions-runner/config.sh \
  --url https://github.com/${github_repo} \
  --token $github_token \
  --unattended \
  --labels $runner_label"

# --- Create systemd service ---
cat <<EOF | sudo tee /etc/systemd/system/actions.runner.service > /dev/null
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

sudo systemctl daemon-reload
sudo systemctl enable actions.runner
sudo systemctl start actions.runner

echo "GitHub Actions runner setup complete." >> /var/log/github-runner.log
