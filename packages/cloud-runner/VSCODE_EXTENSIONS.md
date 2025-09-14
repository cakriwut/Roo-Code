# VS Code Extensions Management

This directory contains configuration for managing VS Code extensions in the Docker runner environment.

## Files

### `vscode-extensions.txt`

A simple text file containing the list of VS Code extensions to be installed in the Docker container. Each line should contain:

- Extension ID with version (e.g., `golang.go@0.46.1`)
- Comments (lines starting with `#`)
- Empty lines are ignored

### `scripts/install-vscode-extensions.sh`

A shell script that reads the `vscode-extensions.txt` file and installs each extension using the VS Code CLI.

## Usage

To add or remove VS Code extensions:

1. Edit `packages/evals/vscode-extensions.txt`
2. Add/remove/modify extension entries
3. Rebuild the Docker container

Example `vscode-extensions.txt`:

```
# Language support
golang.go@0.46.1
ms-python.python@2025.6.1

# Code quality
dbaeumer.vscode-eslint@3.0.10

# Additional extensions
redhat.java@1.42.0
rust-lang.rust-analyzer@0.3.2482
```

## Migration from hardcoded extensions

Previously, extensions were hardcoded in the Dockerfile with ARG variables. The new approach:

- Provides better maintainability
- Allows easier extension management without Dockerfile changes
- Supports comments and documentation
- Is more flexible for different environments
