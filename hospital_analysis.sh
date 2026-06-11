#!/bin/bash

process_vitals() {
    echo "============================================="
    echo "  [M5] Processing Critical Vitals            "
    echo "============================================="

    local heart_log="active_logs/heart_rate_log.log"
    local temp_log="active_logs/temperature_log.log"
    local output="reports/critical_alerts.txt"

    mkdir -p reports
    > "$output"

    {
        echo "KNH CRITICAL ALERTS REPORT"
        echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "============================================="
    } >> "$output"

    echo "" >> "$output"
    echo "--- CRITICAL: Heart Rate (BPM) ---" >> "$output"

    if [ -f "$heart_log" ]; then
        grep "CRITICAL" "$heart_log" | awk -F" [|] " '
            {printf "  Timestamp: %-22s  Device: %-18s  BPM: %s\n", $1, $2, $3}
        ' >> "$output"
        local hr_count
        hr_count=$(grep -c "CRITICAL" "$heart_log")
        echo "  [M5] Heart Rate CRITICAL entries found: $hr_count"
    else
        echo "  [WARN] Log not found: $heart_log"
        echo "  [NO DATA] Heart rate log unavailable." >> "$output"
    fi

    echo "" >> "$output"
    echo "--- CRITICAL: Temperature (Celsius) ---" >> "$output"

    if [ -f "$temp_log" ]; then
        grep "CRITICAL" "$temp_log" | awk -F" [|] " '
            {printf "  Timestamp: %-22s  Device: %-18s  Temp: %s C\n", $1, $2, $3}
        ' >> "$output"
        local temp_count
        temp_count=$(grep -c "CRITICAL" "$temp_log")
        echo "  [M5] Temperature CRITICAL entries found: $temp_count"
    else
        echo "  [WARN] Log not found: $temp_log"
        echo "  [NO DATA] Temperature log unavailable." >> "$output"
    fi

    echo ""
    echo "  [M5] Critical alerts saved to: $output"
    echo ""
}

water_audit() {
    echo "============================================="
    echo "  [M6] ICU Water Reserve Audit               "
    echo "============================================="

    local water_log="active_logs/water_usage_log.log"

    if [ ! -f "$water_log" ]; then
        echo "  [WARN] Water usage log not found: $water_log"
        echo ""
        return 1
    fi

    local result
    result=$(awk -F" [|] " '
        $2 ~ /ICU_WATER_RESERVE/ {
            sum += $3
            count++
        }
        END {
            if (count > 0)
                printf "%.2f|%d", sum / count, count
            else
                printf "0.00|0"
        }
    ' "$water_log")

    local avg count
    avg=$(echo "$result"  | cut -d'|' -f1)
    count=$(echo "$result" | cut -d'|' -f2)

    echo ""
    printf "\n"
    printf "      ICU WATER RESERVE — AUDIT REPORT    \n"
    printf "\n"
    printf "Device     : %-26s║\n" "ICU_WATER_RESERVE"
    printf "Log File   : %-26s║\n" "$water_log"
    printf "Readings   : %-26s║\n" "$count"
    printf "Avg Usage  : %-23s L/min║\n" "$avg"
    echo ""
    echo "  [M6] Water audit complete."
    echo ""
}

echo ""
echo "#############################################"
echo "#   KNH Hospital Analysis — Starting...     #"
echo "#############################################"
echo ""

process_vitals
water_audit

echo "============================================="
echo "   Analysis Complete"
echo "   Date: $(date '+%A, %d %B %Y  %H:%M:%S')"
echo "============================================="
echo ""
