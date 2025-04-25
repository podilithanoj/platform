#!/bin/bash

set -e

# Update system
apt-get update -y

# Install dependencies
apt-get install -y git curl jq unzip software-properties-common

# ----------------------
# Install JDK 17
# ----------------------
add-apt-repository -y ppa:openjdk-r/ppa
apt-get update -y
apt-get install -y openjdk-17-jdk

# Verify JDK install
java -version

# ----------------------
# Install Maven
# ----------------------
apt-get install -y maven
mvn -version

# ----------------------
# Install JFrog CLI
# ----------------------
curl -fL https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/jfrog-cli-linux-amd64/ | tee jfrog > /dev/null
chmod +x jfrog
mv jfrog /usr/local/bin/

# Verify JFrog CLI
jfrog --version

# ----------------------
# GitHub Actions Runner Setup
# ----------------------

mkdir -p /actions-runner && cd /actions-runner

curl -O -L https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-linux-x64-${runner_version}.tar.gz
tar xzf ./actions-runner-linux-x64-${runner_version}.tar.gz

./bin/installdependencies.sh

./config.sh --url https://github.com/${github_repo} \
            --token ${github_token} \
            --unattended \
            --labels terraform-runner

# Optional: Run as a service or foreground
./run.sh
