#!/usr/bin/env bash

# Configuration file path
CONFIG_DIR="$HOME/.config/ocr2clipboard"
CONFIG_FILE="$CONFIG_DIR/language"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Get language preference
if [ -f "$CONFIG_FILE" ]; then
    CURRENT_LANG=$(cat "$CONFIG_FILE")
fi

# Ask user for language preference with kdialog
SELECTED_LANG=$(kdialog --combobox "Select language for text recognition" $(tesseract --list-langs | tail -n+2) --title "Language" --default "${CURRENT_LANG:-$(tesseract --list-langs | tail -n+2 | head -1)}")

# Check if user cancelled the language dialog
if [ $? -ne 0 ]; then
    # User cancelled, exit
    exit 0
else
    # Ask if user wants to save the setting
    if [ ! -s "$CONFIG_FILE" ]; then
        if kdialog --yesno "Do you want to save the settings?\n\nBy saving it will store the selected value (${CURRENT_LANG}) as default\nuntil you delete the config file ${CONFIG_FILE}." --title "Save settings"; then
            # User wants to save the setting
            echo "$SELECTED_LANG" > "$CONFIG_FILE"
        fi
    fi
fi

# Perform OCR with selected language
dbus-send --type=method_call --dest=org.kde.klipper /klipper org.kde.klipper.klipper.setClipboardContents string:"$(tesseract -l "$SELECTED_LANG" "$1" stdout)"

if [ $? -eq 0 ]; then
    notify-send -a Dolphin -i application-png "Copy text from image" "Text successfully copied to clipboard (Language: $SELECTED_LANG)"
else
    notify-send -a Dolphin -i application-png "Copy text from image" "There was an error during text recognition."
fi
