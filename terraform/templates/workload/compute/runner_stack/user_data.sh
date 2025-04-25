#!/bin/bash
apt-get update -y
apt-get install -y git curl jq

# GitHub Actions Runner Setup
runner_version="2.308.0"
mkdir /actions-runner && cd /actions-runner
curl -O -L https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-linux-x64-${runner_version}.tar.gz
tar xzf ./actions-runner-linux-x64-${runner_version}.tar.gz

./bin/installdependencies.sh

./config.sh --url https://github.com/${github_repo} \
            --token ${github_token} \
            --unattended \
            --labels terraform-runner

./run.sh
