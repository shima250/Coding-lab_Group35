#!/bin/bash

ACTIVE_DIR="active_logs"
ARCHIVE_DIR="archived_logs"

archive_logs() {
    echo "Starting archiving - $(date '+%Y-%m-%d %H:%M:%S')"

    if [ ! -d "$ACTIVE_DIR" ]; then
        echo "[ERROR] active_logs folder not found."
        exit 1
    fi

    if [ ! -d "$ARCHIVE_DIR" ]; then
        mkdir -p "$ARCHIVE_DIR"
        echo "[INFO] archived_logs folder created."
    fi

    TIMESTAMP=$(date '+%Y%m%d_%H%M')
    FILE_COUNT=$(ls "$ACTIVE_DIR"/*.log 2>/dev/null | wc -l)

    if [ "$FILE_COUNT" -eq 0 ]; then
        echo "[INFO] No log files found."
        exit 0
    fi

    for LOG_FILE in "$ACTIVE_DIR"/*.log; do
        BASENAME=$(basename "$LOG_FILE" .log)
        NEW_NAME="${BASENAME}_${TIMESTAMP}.log"
        mv "$LOG_FILE" "$ARCHIVE_DIR/$NEW_NAME"
        echo "[ARCHIVED] $BASENAME.log --> $NEW_NAME"
    done

    for ARCHIVED_FILE in "$ARCHIVE_DIR"/*_${TIMESTAMP}.log; do
        FULL_NAME=$(basename "$ARCHIVED_FILE")
        ORIGINAL_NAME="${FULL_NAME%_${TIMESTAMP}.log}.log"
        > "$ACTIVE_DIR/$ORIGINAL_NAME"
        echo "[RECREATED] $ORIGINAL_NAME empty and ready"
    done

    echo "Archiving completed successfully!"
}

archive_logs
