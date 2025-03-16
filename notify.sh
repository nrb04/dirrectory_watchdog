#!/bin/bash

# Directory to monitor
DIR_TO_WATCH="/home/badhon/Desktop/work /march/watchdog"

# Log file to record events
LOG_FILE="/home/badhon/Desktop/work /march/logfile.log"

# Ensure the log file exists
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
