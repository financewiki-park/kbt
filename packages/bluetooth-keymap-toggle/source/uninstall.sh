#!/bin/sh
set -eu

if [ "${1:-}" = upgrade ]; then
    exit 0
fi

USERSTORE=${KPM_USERSTORE:-/mnt/us}
SCRIPTLET="$USERSTORE/documents/Bluetooth_Keymap_Toggle.sh"

pkill -TERM -f 'kindle-button-mapper' >/dev/null 2>&1 || true
pkill -TERM -f 'kindle-hid-passthrough --daemon' >/dev/null 2>&1 || true
pkill -TERM -f 'main.py --daemon' >/dev/null 2>&1 || true
pkill -TERM -f 'ld-linux-armhf.' >/dev/null 2>&1 || true

if [ -f "$SCRIPTLET" ]; then
    installed_hash=$(md5sum "$SCRIPTLET" | awk '{print $1}')
    package_hash=$(md5sum scriptlets/Bluetooth_Keymap_Toggle.sh | awk '{print $1}')
    if [ "$installed_hash" = "$package_hash" ]; then
        rm -f "$SCRIPTLET"
    else
        echo "Kept modified scriptlet: $SCRIPTLET"
    fi
fi

echo "Uninstalled. HID and key mapping processes were stopped."
exit 0
