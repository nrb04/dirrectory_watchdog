#!/bin/bash

# Directory to monitor
DIR_TO_WATCH="/home/badhon/Desktop/work/march/watchdog"

# Base directory for log files
LOG_DIR="/home/badhon/Desktop/work/march/log"

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Function to generate a new log file daily
generate_log_file() {
    TODAY=$(date '+%Y-%m-%d')
    LOG_INDEX=1

    # Find the next available log file number for today
    while [[ -f "$LOG_DIR/${TODAY}_$LOG_INDEX.log" ]]; do
        ((LOG_INDEX++))
    done

    LOG_FILE="$LOG_DIR/${TODAY}_$LOG_INDEX.log"
    touch "$LOG_FILE"
}

# Initialize the log file
generate_log_file

# Function to log events with timestamp and file size
log_event() {
    local FILE_PATH="$1"
    local EVENT_TYPE="$2"

    # Check if it's a new day and update log file
    CURRENT_DATE=$(date '+%Y-%m-%d')
    if [[ "$CURRENT_DATE" != "$TODAY" ]]; then
        generate_log_file
    fi

    # Get file size if the file exists
    if [[ -f "$FILE_PATH" ]]; then
        FILE_SIZE=$(stat -c%s "$FILE_PATH")  # Get file size in bytes
    else
        FILE_SIZE="N/A"  # If file doesn't exist (e.g., deleted), mark size as N/A
    fi

    echo "$(date '+%Y-%m-%d %H:%M:%S') | File: $FILE_PATH | Event: $EVENT_TYPE | Size: $FILE_SIZE bytes" >> "$LOG_FILE"
}

# Start monitoring the directory
inotifywait -m -r -e create,delete,modify,move "$DIR_TO_WATCH" --format '%w%f %e' | while read FILE EVENT
do
    log_event "$FILE" "$EVENT"
done
