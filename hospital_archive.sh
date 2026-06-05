#!/bin/bash

rotate_logs() {
    echo "============================================="
    echo "  [M4] KNH Log Rotation — Archiving Logs     "
    echo "============================================="

    local source_dir="active_logs"
    local archive_dir="archived_logs"

    if [ ! -d "$source_dir" ]; then
        echo "  [ERROR] '$source_dir' not found."
        echo "          Run hospital_admin.sh first to initialise the system."
        exit 1
    fi

    mkdir -p "$archive_dir"

    local timestamp
    timestamp=$(date '+%Y%m%d_%H%M')
    echo "  [INFO]  Archive timestamp : $timestamp"
    echo ""

    local found=0
    for log_file in "$source_dir"/*.log; do

        [ -f "$log_file" ] || continue
        found=1

        local filename
        filename=$(basename "$log_file")
        local base="${filename%.log}"
        local archive_name="${base}_${timestamp}.log"
        local archive_path="${archive_dir}/${archive_name}"

        echo "  [MOVE]  $filename  →  archived_logs/$archive_name"
        mv "$log_file" "$archive_path"

        if [ $? -eq 0 ]; then
            echo "  [OK]    Archived successfully."
        else
            echo "  [ERROR] Failed to archive '$filename'. Skipping."
            continue
        fi

        touch "${source_dir}/${filename}"
        echo "  [RESET] Recreated empty '${source_dir}/${filename}' for engine continuity."
        echo ""
    done

    if [ "$found" -eq 0 ]; then
        echo "  [INFO] No .log files found in '$source_dir'. Nothing to archive."
        echo ""
    fi

    echo "============================================="
    echo "  [M4] Log rotation complete."
    echo "  Archived files stored in: $archive_dir/"
    echo "============================================="
    echo ""
}

echo ""
echo "#############################################"
echo "#   KNH Log Archiver — Starting...          #"
echo "#############################################"
echo ""

rotate_logs

echo "============================================="
echo "   Archive Job Complete"
echo "   Date: $(date '+%A, %d %B %Y  %H:%M:%S')"
echo "============================================="
echo ""
