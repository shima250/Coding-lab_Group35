#!/bin/bash

initialize_system() {
    echo "============================================="
    echo "  [M1] Initializing KNH Directory Structure  "
    echo "============================================="

    local dirs=("active_logs" "archived_logs" "reports")

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "  [OK]      '$dir' already exists. Skipping."
        else
            echo "  [CREATE]  Creating '$dir' directory..."
            mkdir -p "$dir"
            echo "  [DONE]    '$dir' created successfully."
        fi
    done

    echo ""
    echo "  [M1] Directory initialization complete."
    echo ""
}

secure_data() {
    echo "============================================="
    echo "  [M2] Securing KNH Data Directories         "
    echo "============================================="

    local target="active_logs"

    if [ ! -d "$target" ]; then
        echo "  [ERROR] '$target' not found. Run initialize_system() first."
        return 1
    fi

    echo "  [SECURING] Applying chmod 700 to '$target' directory..."
    chmod 700 "$target"

    echo "  [SECURING] Applying chmod 600 to all log files inside '$target'..."
    find "$target" -type f -name "*.log" -exec chmod 600 {} \;

    echo ""
    echo "  [PERMISSIONS] Current permissions for '$target':"
    echo "  -----------------------------------------------"
    ls -ld "$target"
    echo "  -----------------------------------------------"
    echo ""
    echo "  [M2] Security hardening complete."
    echo ""
}

echo ""
echo "#############################################"
echo "#   KNH Hospital Admin Setup — Starting...  #"
echo "#############################################"
echo ""

initialize_system
secure_data

echo "============================================="
echo "   System Environment Secured"
echo "   Date: $(date '+%A, %d %B %Y  %H:%M:%S')"
echo "============================================="
echo ""
