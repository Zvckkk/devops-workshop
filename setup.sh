#!/usr/bin/env bash
set -e

# DevOps Workshop Setup Script
# Usage: ./setup.sh <tool>
# Example: ./setup.sh docker

show_usage() {
    echo "=== DevOps Workshop Setup Script ==="
    echo ""
    echo "Usage: $0 <tool>"
    echo ""
    echo "Available tools:"
    echo "  docker       - Install Docker Engine"
    echo "  ansible      - Install Ansible automation tool"
    echo "  github       - Install GitHub CLI and actions tools"
    echo "  k0s          - Install K0s Kubernetes distribution"
    echo "  cloudsmith   - Install CloudSmith package tools"
    echo ""
    echo "Examples:"
    echo "  $0 docker"
    echo "  $0 ansible"
    echo "  $0 k0s"
    echo ""
}

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No tool specified."
    echo ""
    show_usage
    exit 1
fi

TOOL=$1

# Validate and run the appropriate setup script
case $TOOL in
    docker)
        echo "Setting up Docker..."
        if [ -f "./scripts/setup-docker.sh" ]; then
            chmod +x ./scripts/setup-docker.sh
            ./scripts/setup-docker.sh
        else
            echo "Error: scripts/setup-docker.sh not found."
            exit 1
        fi
        ;;
    ansible)
        echo "Setting up Ansible..."
        if [ -f "./scripts/setup-ansible.sh" ]; then
            chmod +x ./scripts/setup-ansible.sh
            ./scripts/setup-ansible.sh
        else
            echo "Error: scripts/setup-ansible.sh not found."
            exit 1
        fi
        ;;
    github)
        echo "Setting up GitHub tools..."
        if [ -f "./scripts/setup-github-actions.sh" ]; then
            chmod +x ./scripts/setup-github-actions.sh
            ./scripts/setup-github-actions.sh
        else
            echo "Error: scripts/setup-github-actions.sh not found."
            exit 1
        fi
        ;;
    k0s)
        echo "Setting up K0s..."
        if [ -f "./scripts/setup-k0s.sh" ]; then
            chmod +x ./scripts/setup-k0s.sh
            ./scripts/setup-k0s.sh
        else
            echo "Error: scripts/setup-k0s.sh not found."
            exit 1
        fi
        ;;
    cloudsmith)
        echo "Setting up CloudSmith..."
        if [ -f "./scripts/setup-cloudsmith.sh" ]; then
            chmod +x ./scripts/setup-cloudsmith.sh
            ./scripts/setup-cloudsmith.sh
        else
            echo "Error: scripts/setup-cloudsmith.sh not found."
            exit 1
        fi
        ;;
    help|--help|-h)
        show_usage
        exit 0
        ;;
    *)
        echo "Error: Unknown tool '$TOOL'"
        echo ""
        show_usage
        exit 1
        ;;
esac

echo ""
echo "=== Setup completed for $TOOL! ==="