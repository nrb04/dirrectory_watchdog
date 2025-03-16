#!/bin/bash

# Directory to monitor
DIR_TO_WATCH="/home/badhon/Desktop/work/march/watchdog"

# Base directory for log files
LOG_DIR="/home/badhon/Desktop/work/march/log"

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Get today's date
TODAY=$(date '+%Y-%m-%d')

# Find the next available log file number
LOG_INDEX=1
while [[ -f "$LOG_DIR/${TODAY}_$LOG_INDEX.log" ]]; do
    ((LOG_INDEX++))
done

# Set log file name
LOG_FILE="$LOG_DIR/${TODAY}_$LOG_INDEX.log"

# Create the log file
touch "$LOG_FILE"

# Function to log events with a timestamp
log_event() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

# Start monitoring the directory
inotifywait -m -r -e create,delete,modify,move "$DIR_TO_WATCH" --format '%w%f %e' | while read FILE EVENT
do
    log_event "File: $FILE Event: $EVENT"
done
