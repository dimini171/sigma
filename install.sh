#!/bin/bash

# ensure script exits on errors
set -euo pipefail

REPO_OWNER="dimini171"
REPO_NAME="sigma"
EXEC_NAME="sigma"
INSTALL_PATH="/usr/bin/"
MIN_SIZE=100000 

# user confirmation
echo "This script installs ${REPO_OWNER}/${REPO_NAME} to ${INSTALL_PATH}"
echo "Note: sudo access is required to install to ${INSTALL_PATH}"
read -r -n 1 -p "Proceed? (y/N) " CONTINUE < /dev/tty

[[ "$CONTINUE" =~ [yY] ]] || { echo "Exiting..."; exit 0; }

# os validation
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$OS" in
    linux|darwin) ;;
    *) echo "Error: Unsupported OS"; exit 1 ;;
esac

# architecture detection
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="x86_64" ;;
    arm64|aarch64) ARCH="aarch64" ;;
    *) echo "Error: Unsupported arch: $ARCH"; exit 1 ;;
esac

# dependency checks
for cmd in curl grep sed; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd required"; exit 1; }
done

# get latest release tag
API_URL="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest"
if command -v jq >/dev/null 2>&1; then
    LATEST=$(curl -s "$API_URL" | jq -r '.tag_name')
else
    LATEST=$(curl -s "$API_URL" | grep -oP '"tag_name": "\K[^"]+')
fi

[ -n "$LATEST" ] || { echo "Failed to fetch release"; exit 1; }

# download executable
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/${LATEST}/${EXEC_NAME}-${ARCH}"
echo "Downloading: $DOWNLOAD_URL"
curl -L -o "$EXEC_NAME" "$DOWNLOAD_URL" || { echo "Download failed"; exit 1; }

# validate file size
file_size=$(wc -c < "$EXEC_NAME")
if (( file_size < MIN_SIZE )); then
    echo "Error: File too small - likely invalid build"
    rm -f "$EXEC_NAME"
    exit 1
fi

# install
chmod +x "$EXEC_NAME"
sudo mv "$EXEC_NAME" "${INSTALL_PATH}${EXEC_NAME}"
echo "Installed to ${INSTALL_PATH}${EXEC_NAME}"
