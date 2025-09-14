#!/bin/bash
set -e

# Script to install VS Code extensions from vscode-extensions.txt
# This script reads the vscode-extensions.txt file and installs each extension

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="${SCRIPT_DIR}/../vscode-extensions.txt"
VSCODE_DATA_DIR="${1:-/roo/.vscode-template}"

echo "Installing VS Code extensions from ${EXTENSIONS_FILE}"
echo "Using VS Code data directory: ${VSCODE_DATA_DIR}"

# Check if extensions file exists
if [ ! -f "${EXTENSIONS_FILE}" ]; then
    echo "Error: Extensions file ${EXTENSIONS_FILE} not found"
    exit 1
fi

# Create the VS Code data directory if it doesn't exist
mkdir -p "${VSCODE_DATA_DIR}"

# Read extensions file and install each extension
while IFS= read -r line; do
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    # Trim whitespace
    extension=$(echo "$line" | xargs)
    
    if [[ -n "$extension" ]]; then
        echo "Installing extension: $extension"
        yes | code --no-sandbox --user-data-dir "${VSCODE_DATA_DIR}" --install-extension "$extension"
    fi
done < "${EXTENSIONS_FILE}"

echo "All VS Code extensions installed successfully"