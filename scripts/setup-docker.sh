#!/usr/bin/env bash
set -e

echo "=== Docker Setup for WSL (Ubuntu) ==="

# Check if running in WSL
if grep -qi microsoft /proc/version; then
  echo "Running inside WSL"
else
  echo "This script is intended for WSL environments only."
  exit 1
fi

# Update packages
echo "Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

# Remove old versions
echo "Removing old Docker versions (if any)..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# Install dependencies
echo "Installing prerequisites..."
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker’s official GPG key
echo "Adding Docker GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
echo "Installing Docker Engine..."
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker service
echo "Starting Docker service..."
sudo service docker start

# Add current user to docker group
echo "Granting non-root access to Docker..."
sudo usermod -aG docker $USER

# Verify installation
echo "Verifying Docker installation..."
docker version || echo " Please restart your terminal or WSL, then run: docker run hello-world"

echo "=== Docker setup complete! ==="
echo " Close and reopen your terminal, then test with:"
echo "    docker run hello-world"
