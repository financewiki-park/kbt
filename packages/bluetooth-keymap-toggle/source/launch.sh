#!/bin/sh
set -u

USERSTORE=${KPM_USERSTORE:-/mnt/us}
HID_DIR="$USERSTORE/kindle_hid_passthrough"
MAP_DIR="$USERSTORE/kindle-button-mapper"
HID_BIN="$HID_DIR/kindle-hid-passthrough"
MAP_BIN="$MAP_DIR/kindle-button-mapper"
MAP_CONF="$MAP_DIR/config.ini"
LOG="$HID_DIR/toggle.log"

log() {
    printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$LOG"
    echo "$*"
}

show_result() {
    title=$1
    message=$2
    title_escaped=$(printf '%s' "$title" | sed 's/"/\\\\"/g')
    message_escaped=$(printf '%s' "$message" | sed 's/"/\\\\"/g')
    json='{ "clientParams":{ "alertId":"appAlert1", "show":true, "customStrings":[ { "matchStr":"alertTitle", "replaceStr":"'"$title_escaped"'" }, { "matchStr":"alertText", "replaceStr":"'"$message_escaped"'" } ] } }'
    lipc-set-prop com.lab126.pillow pillowAlert "$json" >/dev/null 2>&1 || true
}

hid_running() {
    pgrep -f 'ld-linux-armhf.' >/dev/null 2>&1 || \
        pgrep -f 'main.py --daemon' >/dev/null 2>&1
}

mapper_running() {
    pgrep -f 'kindle-button-mapper' >/dev/null 2>&1
}

stop_services() {
    log "Stopping Bluetooth key mapping"
    # These jobs may have been installed as Upstart services.  Stopping only
    # their child processes lets Upstart immediately spawn them again.
    /sbin/initctl stop kindle-button-mapper >/dev/null 2>&1 || \
        /sbin/stop kindle-button-mapper >/dev/null 2>&1 || true
    /sbin/initctl stop hid-passthrough >/dev/null 2>&1 || \
        /sbin/stop hid-passthrough >/dev/null 2>&1 || true
    pkill -TERM -f 'kindle-button-mapper' >/dev/null 2>&1 || true
    pkill -TERM -f 'kindle-hid-passthrough --daemon' >/dev/null 2>&1 || true
    pkill -TERM -f 'main.py --daemon' >/dev/null 2>&1 || true
    pkill -TERM -f 'ld-linux-armhf.' >/dev/null 2>&1 || true
    i=0
    while [ "$i" -lt 15 ] && { hid_running || mapper_running; }; do
        sleep 1
        i=$((i + 1))
    done
    if hid_running || mapper_running; then
        log "ERROR: A service did not stop cleanly"
        show_result "Bluetooth + Key Mapping" "OFF failed. A process is still stopping.\n\nPress OK to close."
        return 1
    fi
    log "Bluetooth + Key Mapping: OFF"
    show_result "Bluetooth + Key Mapping" "Status: OFF\n\nPress OK to close."
}

start_services() {
    if [ ! -x "$HID_BIN" ]; then
        log "ERROR: Missing HID program: $HID_BIN"
        show_result "Bluetooth + Key Mapping" "ON failed: HID program is missing.\n\nPress OK to close."
        return 1
    fi
    if [ ! -x "$MAP_BIN" ] || [ ! -f "$MAP_CONF" ]; then
        log "ERROR: Missing key mapper program or configuration"
        show_result "Bluetooth + Key Mapping" "ON failed: key mapping files are missing.\n\nPress OK to close."
        return 1
    fi

    log "Starting Bluetooth key mapping"
    (cd "$MAP_DIR" && "$MAP_BIN" "$MAP_CONF" >> "$LOG" 2>&1 &)
    (cd "$HID_DIR" && "$HID_BIN" --daemon >> "$LOG" 2>&1 &)
    i=0
    while [ "$i" -lt 15 ]; do
        if hid_running && mapper_running; then
            log "Bluetooth + Key Mapping: ON"
            show_result "Bluetooth + Key Mapping" "Status: ON\n\nPress OK to close."
            return 0
        fi
        sleep 1
        i=$((i + 1))
    done

    log "ERROR: Service start failed"
    stop_services >/dev/null 2>&1 || true
    show_result "Bluetooth + Key Mapping" "ON failed. Details were saved in the log.\n\nPress OK to close."
    echo "Start failed. A log was saved in kindle_hid_passthrough."
    return 1
}

mkdir -p "$HID_DIR"
log "Toggle started"
if hid_running || mapper_running; then
    stop_services
else
    start_services
fi
