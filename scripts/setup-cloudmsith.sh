# Update system and install dependencies
sudo apt update
sudo apt install -y curl jq

# Install Cloudsmith CLI
curl -1sLf 'https://dl.cloudsmith.io/public/cloudsmith/cli/setup.deb.sh' | sudo -E bash
sudo apt install -y cloudsmith-cli

# Verify installation
cloudsmith --version
