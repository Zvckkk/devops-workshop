#!/usr/bin/env bash
set -e
echo "=== CloudSmith CLI Setup ==="

# Update system and install dependencies
sudo apt-get update
sudo apt-get install -y curl jq

# Install Cloudsmith CLI
curl -s https://api.github.com/repos/cloudsmith-io/cloudsmith-cli/releases/latest \
    | sed -n 's/.*"browser_download_url": "\(.*cloudsmith.pyz\)".*/\1/p' \
    | xargs wget -qO cloudsmith.pyz

# Make the downloaded file executable
chmod +x ./cloudsmith.pyz

# Move the executable to /usr/local/bin
sudo mv ./cloudsmith.pyz /usr/local/bin/cloudsmith

# Verify installation
cloudsmith --version