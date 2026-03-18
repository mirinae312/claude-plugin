---
description: Install all tools required by this plugin (LSP servers, checkstyle, jq). Run this once after enabling the plugin.
disable-model-invocation: true
---

## Goal

Check and install all tools required by this plugin. Skip tools that are already installed. Never install a tool without telling the user first.

## Required tools

| Tool | Purpose |
|------|---------|
| `java` | Checkstyle hook (Google Java Style) |
| `jq` | JSON parsing in hooks |
| `jdtls` | Java LSP |
| `pylsp` | Python LSP |
| `typescript-language-server` | JavaScript / TypeScript LSP |
| `bash-language-server` | Bash LSP |

## Steps

### 1. Detect the OS and package manager

- Run `uname -s` to determine the OS.
- **macOS**: check for `brew` → if missing, prompt the user to install Homebrew first and stop.
- **Linux (Debian/Ubuntu)**: use `apt-get`.
- **Linux (Arch)**: use `pacman`.
- **Other**: inform the user that automatic installation is not supported and list the tools manually.

### 2. Check what is already installed

For each tool, run the appropriate check:

| Tool | Check command |
|------|--------------|
| `java` | `java -version` |
| `jq` | `jq --version` |
| `jdtls` | `which jdtls` |
| `pylsp` | `which pylsp` |
| `typescript-language-server` | `which typescript-language-server` |
| `bash-language-server` | `which bash-language-server` |

Collect the list of missing tools. If everything is already installed, report success and stop.

### 3. Confirm with the user

Show the list of tools that will be installed and the commands that will be run. Ask the user to confirm before proceeding.

### 4. Install missing tools

Install only the tools the user confirmed. Use the commands below for each OS.

**macOS (Homebrew)**
```
brew install jdtls          # java + jdtls
brew install jq
brew install python-lsp-server   # pylsp
npm install -g typescript-language-server typescript
npm install -g bash-language-server
```
> Note: `jdtls` via Homebrew bundles a JDK. If `java` is already present, skip the jdtls brew install and install jdtls separately.

**Linux (apt)**
```
sudo apt-get update
sudo apt-get install -y default-jdk jq
pip install python-lsp-server
npm install -g typescript-language-server typescript
npm install -g bash-language-server
# jdtls: download from https://github.com/eclipse-jdtls/eclipse.jdt.ls/releases
```

### 5. Verify installation

Re-run the check commands from Step 2 for each tool that was installed. Report which tools succeeded and flag any that still cannot be found, with a suggested fix.
