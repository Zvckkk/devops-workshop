#!/usr/bin/env bash
set -e
echo "=== CloudSmith CLI Setup ==="

# Update system and install dependencies
sudo apt-get update
sudo apt-get install -y curl jq

# Install Cloudsmith CLI
python3 -m venv .cloudsmith-env
source .cloudsmith-env/bin/activate
pip install --upgrade cloudsmith-cli

# Verify installation
if command -v cloudsmith >/dev/null 2>&1; then
    echo "Success: Cloudsmith CLI version $(cloudsmith --version) is installed."
else
    echo "Error: Installation failed."
    exit 1
fi