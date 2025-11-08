#!/bin/bash

LOG_DIR="$HOME/daily_logs"
ARCHIVE_DIR="$LOG_DIR/archive"
mkdir -p "$LOG_DIR" "$ARCHIVE_DIR"

LOG_FILE="$LOG_DIR/log_$(date +%Y-%m-%d).txt"

{
  echo "============================="
  echo "System Log for: $(date)"
  echo "User: $(whoami)"
  echo "============================="
  echo
  echo "Uptime:"
  uptime
  echo
  echo "Top 5 CPU-consuming processes:"
  ps -eo pid,comm,%mem,%cpu --sort=-%cpu | head -n 6
  echo
  echo "Disk Usage:"
  df -h
} > "$LOG_FILE"

echo "Log created successfully at $LOG_FILE"

find "$LOG_DIR" -name "log_*.txt" -mtime +7 -exec mv {} "$ARCHIVE_DIR" \;
if [ "$(date +%u)" -eq 7 ]; then
  tar -czf "$ARCHIVE_DIR/weeklylogs_$(date +%Y-%m-%d).tar.gz" -C "$ARCHIVE_DIR" .
  echo "Weekly archive created."
fi


if [ -f "$LOG_FILE" ]; then
    mail -s "Daily System Log - $(date +%Y-%m-%d)" vivek.raj915568@gmail.com < "$LOG_FILE"
    echo "Log emailed to local mailbox: vivek.raj915568@gmail.com"
else
    echo "No log file found for today!"
fi
```

