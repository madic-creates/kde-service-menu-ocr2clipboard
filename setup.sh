#!/bin/bash

BIN_DIR="$HOME/.local/bin"
SERVICE_MENU_DIR="$HOME/.local/share/kio/servicemenus"

usage() {
    echo "Usage: $0 [-i|-u]"
    echo "  -i: Installation"
    echo "  -u: Uninstallation"
    exit 1
}

# Check parameters
if [ $# -ne 1 ]; then
    usage
fi

case "$1" in
    -i)
        [ ! -d "$BIN_DIR" ] && mkdir -pv "$BIN_DIR"
        [ ! -d "$SERVICE_MENU_DIR" ] && mkdir -pv "$SERVICE_MENU_DIR"
        cp -v ocr2clipboard.sh "$BIN_DIR/"
        cp -v ocr2clipboard.desktop "$SERVICE_MENU_DIR/"
        echo "Installation successful."
        ;;
    -u)
        rm -fv "$BIN_DIR/ocr2clipboard.sh" "$SERVICE_MENU_DIR/ocr2clipboard.desktop"
        echo "Uninstallation successful."
        ;;
    *)
        usage
        ;;
esac
