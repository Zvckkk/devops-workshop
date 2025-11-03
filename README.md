# Workshop Setup Guide for WSL

This guide will help you set up the tools needed on Ubuntu running in WSL (Windows Subsystem for Linux).

## Prerequisites

Before running the setup script, ensure you have:

- **Windows 10/11** with WSL2 enabled
- **Ubuntu distribution** installed in WSL
- **Internet connection** for downloading packages
- **Administrator access** on Windows for WSL setup

## WSL Setup Requirements

### 1. Install WSL2 on Windows

Open **PowerShell as Administrator** and run:

```powershell
wsl --install
```

Restart your computer when prompted.

### 2. Install Ubuntu Distribution

You can install Ubuntu from the Microsoft Store, or use the command line:

```powershell
wsl --install -d Ubuntu
```

### 3. Update WSL to Version 2

Ensure you're using WSL2 (required for Docker):

```powershell
wsl --set-default-version 2
wsl --set-version Ubuntu 2
```

### 4. Verify WSL Installation

Open Ubuntu from the Start Menu or run:

```powershell
wsl
```

## Available Setup Scripts

This workshop includes a unified setup script that can install various DevOps tools:

| Tool | Command | Description |
|------|---------|-------------|
| **Docker** | `./setup.sh docker` | Container runtime and management |
| **Ansible** | `./setup.sh ansible` | Configuration management and automation |
| **GitHub Actions** | `./setup.sh github` | CI/CD workflows and GitHub CLI |
| **K0s** | `./setup.sh k0s` | Lightweight Kubernetes distribution |
| **CloudSmith** | `./setup.sh cloudsmith` | Package repository management |

## How to Run the Setup Script

### Step 1: Open WSL Ubuntu Terminal

Launch Ubuntu from the Start Menu or Windows Terminal.

### Step 2: Clone the DevOps Workshop Repository

```bash
git clone https://github.com/tagoylo/devops-workshop.git
cd devops-workshop
```

### Step 3: Make the Setup Script Executable

```bash
chmod +x setup.sh
```

### Step 4: Run the Setup Script for Your Chosen Tool

```bash
# Install Docker
./setup.sh docker

# Install Ansible
./setup.sh ansible

# Install GitHub tools
./setup.sh github

# Install K0s Kubernetes
./setup.sh k0s

# Install CloudSmith tools
./setup.sh cloudsmith

# Show help and available options
./setup.sh help
```

## What the Scripts Do

Each setup script will typically:
- ✅ Verify you're running in WSL (where applicable)
- ✅ Update system packages
- ✅ Install prerequisites and dependencies
- ✅ Add official repositories and GPG keys
- ✅ Install the target tool and components
- ✅ Configure the tool for WSL environment
- ✅ Set up user permissions and groups
- ✅ Provide verification steps

## Need Help?

- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Docker Documentation](https://docs.docker.com/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [GitHub CLI Documentation](https://cli.github.com/manual/)

## Next Steps

After successful installation of your chosen tools, you can:
- Explore the individual tool documentation
- Follow along with workshop exercises
- Build and deploy applications using these DevOps tools
- Set up CI/CD pipelines
- Manage infrastructure as code

Happy learning!

