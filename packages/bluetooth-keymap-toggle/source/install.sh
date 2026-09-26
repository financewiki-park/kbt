#!/bin/sh
set -eu

USERSTORE=${KPM_USERSTORE:-/mnt/us}
TARGET="$USERSTORE/documents/Bluetooth_Keymap_Toggle.sh"

mkdir -p "$USERSTORE/documents"
cp scriptlets/Bluetooth_Keymap_Toggle.sh "$TARGET"
chmod +x "$TARGET"

echo "Installed Bluetooth + Key Mapping toggle."
echo "Open it from the Kindle library to switch both services on or off."
exit 0
