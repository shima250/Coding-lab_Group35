#!/bin/bash

# Author: Gwiza Tysha Kansiime and Adriel Mrangaye
# Role: Member 1 and 2 - The Architect and the security lead


# Member 1: The Architect
initialize_system() {
    echo "=== Initializing KNH System Environment ==="
    mkdir -p active_logs archived_logs reports
    echo "All directories are ready!"
    echo "Initialized on: $(date)"
}



# Member 2: The Security Lead
secure_data() {
    echo "=== Securing active_logs Directory ==="

    if [ -d "active_logs" ]; then
        chmod 700 active_logs

        echo "Updated permissions:"
        ls -ld active_logs
        ls -l
    else
        echo "active_logs directory not found."
    fi
}
# Call the function
initialize_system
