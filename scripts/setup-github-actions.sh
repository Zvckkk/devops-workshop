#!/usr/bin/env bash
set -e

echo "Setting up GitHub Actions environment on WSL (Ubuntu)..."

# Verify Docker is installed
if ! command -v docker &> /dev/null; then
  echo "Docker is not installed. Please install Docker first."
  echo "Run your setup-docker.sh script before continuing."
  exit 1
fi

# Install dependencies
sudo apt update -y
sudo apt install -y curl jq

# Install act (GitHub Actions runner)
echo "Installing act..."
curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
sudo mv ./bin/act /usr/local/bin/act
sudo chmod +x /usr/local/bin/act

# Verify installation
echo "Verifying act installation..."
act --version

echo "GitHub Actions local runner (act) setup complete!"
echo "You can now run GitHub Actions locally using:"
echo "  act -l        # List available actions"
echo "  act           # Run default workflow"
