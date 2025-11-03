#!/usr/bin/env bash
set -e

echo "Installing Ansible on WSL (Ubuntu)..."

# Update system and install dependencies
sudo apt update -y
sudo apt install -y software-properties-common curl python3 python3-pip

# Add official Ansible PPA and install
echo "Installing Ansible..."
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# Verify installation
echo "Verifying Ansible installation..."
ansible --version

echo "Ansible installation complete!"
