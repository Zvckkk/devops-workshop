# Cloudsmith

## DevOps Mini Workshop – Session 5

**Ace Alexander Ilog**

---

## Learning Objectives

By the end of this training, you should be able to:

- Understand what Cloudsmith is and how it functions as a cloud‑native artifact repository
- Identify key advantages and limitations of Cloudsmith versus traditional registries
- Use Cloudsmith CLI effectively and apply its core commands
- Integrate Cloudsmith within DevOps workflows and CI/CD pipelines

---

## What is Cloudsmith?

**Cloudsmith** is a fully managed, cloud‑native, multi‑format package repository designed to store, manage, and distribute software artifacts globally.

### Key Characteristics

- Cloud‑hosted
- Universal package support
- Supports multiple formats (PyPI, Docker, Maven, npm, Raw, etc.)
- Integrates with CI/CD tools for automated publishing and retrieval
- REST API support for automation

---

## What is Cloudsmith? (Limitations)

_(Add specific limitations here as needed.)_

---

## Comparison: Cloudsmith vs Traditional Registries

| Feature            | Cloudsmith                                | Traditional Registries (Artifactory/Nexus) |
| ------------------ | ----------------------------------------- | ------------------------------------------ |
| Repository Type    | Universal / Multi-format                  | Format-specific                            |
| Hierarchy          | Flat structure                            | Folder-tree structure                      |
| Package View       | Groups versions & formats of same package | File-based browsing                        |
| Infrastructure     | Cloud-native                              | Server-based                               |
| Query Architecture | Relational database query                 | Boolean-based search                       |

---

## Cloudsmith CLI

Cloudsmith-CLI is a Python-based command-line interface for interacting with Cloudsmith’s API.

### Key Characteristics

- Wraps multiple REST API operations into simple high-level commands
- Supports pushing/pulling packages
- Package listing
- Managing entitlement tokens
- Repository listing
- Built-in authentication handling
- Docker image available for CI/CD usage

---

## Hands-On Exercise

---

## Core Commands

- **cloudsmith whoami** – Check authentication status
- **cloudsmith login/token** – Retrieve your API token
- **cloudsmith list** – List distros, packages, repos, and entitlements
- **cloudsmith push/upload/deploy** – Upload new packages
- **cloudsmith delete** – Delete a package
- **cloudsmith tag** – Add, list, or remove package tags
- **cloudsmith download** – Retrieve packages (latest version if no filters are set)

---

## Command Exercise

### Check the Authentication Status of Cloudsmith-CLI

1. Open WSL:
   - Type in the terminal: `cloudsmith whoami`
     - If your account is not logged in or the config and profile `.ini` files are not set up, it will prompt "anonymous user."
2. Log in to the Cloudsmith CLI using `cloudsmith login`:
   - **Login**: Company email address
   - **Password**: Your device password
     - If your password doesn’t work, change it in Cloudsmith to meet the requirements.
3. After logging in, you will be prompted to create config files containing your credentials and personal API tokens.
4. Retry the `cloudsmith whoami` command.
   - Once done, it should show your authenticated status, e.g.:
     ```
     You are authenticated as:
     User: <Name> (slug: <user-slug>, email: <company email>)
     ```

---

### Fetching Packages in Cloudsmith

1. List all the packages under your repository:
   ```
   cloudsmith list package <namespace>/<repository>
   ```
   Example:
   ```
   cloudsmith list package adi/sdp-devops-miniworkshop
   ```
2. Copy the package name identifier of the file you want to download (e.g., `example-fileraw-<4 commit hash>`).
3. Download the file using:
   ```
   cloudsmith download <namespace>/<repository> <example_fetched_file.raw>
   ```

---

### Uploading Packages in Cloudsmith

Cloudsmith supports packing using the `push/upload` command for multiple formats such as Python, Alpine, Cargo, Composer, CocoaPods, etc.

Command:

```bash
cloudsmith push <format> <OWNER>/<REPOSITORY> <package_file>
```

#### Applying Tags After Upload

Cloudsmith supports tagging packages through package‑management commands:

- Add a tag:
  ```
  cloudsmith tag add <OWNER>/<REPOSITORY> <package_name> <tag_name>
  ```
- Remove a tag:
  ```
  cloudsmith tag remove <OWNER>/<REPOSITORY> <package_name> <tag_name>
  ```
- List tags:
  ```
  cloudsmith tag list <OWNER>/<REPOSITORY> <package_name>
  ```

---

### Uploading Packages With Versioning in Cloudsmith

For some package formats, Cloudsmith extracts the version from inside the package itself, depending on the ecosystem. The version is taken automatically from:

- Metadata inside the package (e.g., `pyproject.toml`, `setup.py`, `Cargo.toml`)
- The filename (when applicable, e.g., `app-1.4.0.tar.gz`)

Example commands:

- For Python packages:
  ```bash
  cloudsmith push python <OWNER>/<REPO> ./dist/app-PACKAGE_VERSION.tar.gz
  ```
- For Debian packages:
  ```bash
  cloudsmith push deb <OWNER>/<REPOSITORY>/<DISTRO>/<VERSION> PACKAGE_NAME-PACKAGE_VERSION.PACKAGE_ARCH.deb
  ```
- For Raw packages:
  ```bash
  cloudsmith push raw <OWNER>/<REPO> --version <PACKAGE_VERSION> <file>
  ```

---

## Implementing Cloudsmith-CLI in CI/CD Pipelines

Cloudsmith maintains a Docker image for the Cloudsmith CLI built for use in CI/CD pipelines and automation environments.

Example:

```yaml
jobs:
  cloudsmith:
    runs-on: ubuntu-latest
    container:
      image: cloudsmith/cloudsmith-cli:1.8.3
    steps:
      - run: cloudsmith whoami
        env:
          CLOUDSMITH_API_KEY: ${{ secrets.CLOUDSMITH_API_KEY }}
```

Cloudsmith Documentations

```
https://help.cloudsmith.io/docs/supported-formats
```

```
https://help.cloudsmith.io/docs/cli

```

https://hub.analog.com/@/tools/cloudsmith/references/faq/

```

Inner source Shared-Actions-docs

```

https://hub.analog.com/catalog/default/component/shared-actions-docs/docs/

```

```
