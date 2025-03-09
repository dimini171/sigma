#!/bin/bash
set -euo pipefail  # enable strict error handling earlier

pip3 install -U PyInstaller

echo "purging ./dist/"
rm -rf dist/

# single PyInstaller command with all necessary parameters
python3 -m PyInstaller \
    --onefile \
    --name "sigma-$(uname -m)" \
    --clean \
    --upx-dir=/usr/bin \
    --exclude-module tkinter \
    --exclude-module unittest \
    --exclude-module pytest \
    --optimize 2 \
    main.py

echo -e "\nexecutable size: \n$(du -sh "dist/sigma-$(uname -m)")"

# determine install path based on architecture
if [[ "$(uname -m)" == "arm64" || "$(uname -m)" == "aarch64" ]]; then
    INSTALL_PATH='/usr/local/bin/'
else
    INSTALL_PATH='/usr/bin/'
fi

echo -e "\nmove to ${INSTALL_PATH} (ENTER) or exit (anything else)?"
read -r CONTINUE < /dev/tty
if [ -n "${CONTINUE}" ]; then
    echo "build at dist/sigma-$(uname -m)"
    exit 0
fi

sudo mv "./dist/sigma-$(uname -m)" "${INSTALL_PATH}sigma"

echo "sigma installed to ${INSTALL_PATH}"
