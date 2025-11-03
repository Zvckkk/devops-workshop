#!/usr/bin/env bash
set -e

echo " Setting up Kubernetes (k0s) on WSL..."

# Install dependencies
sudo apt update -y
sudo apt install -y curl jq

#  Download and install k0s
echo " Installing k0s..."
curl -sSLf https://get.k0s.sh | sudo sh

# Generate config (single node)
echo "⚙️ Generating k0s configuration..."
sudo k0s config create > k0s.yaml

# Install and start controller (single node)
echo "Starting k0s (controller + worker)..."
sudo k0s install controller --single --data-dir /var/lib/k0s
sudo k0s start

# Wait a bit for k0s to initialize
echo " Waiting for cluster to start..."
sleep 15

# Setup kubectl access for the user
echo " Configuring kubectl..."
mkdir -p ~/.kube
sudo k0s kubeconfig admin > ~/.kube/config
chmod 600 ~/.kube/config

# Install kubectl (if missing)
if ! command -v kubectl &> /dev/null; then
  echo "Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi

# Test connection
echo "Verifying cluster..."
kubectl get nodes

echo "k0s setup complete!"
echo "You can now use kubectl normally, e.g.:"
echo "  kubectl get pods -A"
