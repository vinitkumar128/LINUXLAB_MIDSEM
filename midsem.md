## Experiment: [Daily System Logger Script]

### Name: Tanmay Amit Verma, Roll No.: 590029302 Date: 2025-10-18

### AIM:

* To create a shell script that logs current system information, rotates old logs, schedules itself to run daily, and sends the daily log via local email.

### Requirements:

* Any Linux Distro (Pop!_OS)
* Any text editor (VS Code, Vim, Nano, etc.)
* Cron service for scheduling
* Postfix/mailutils for local email

### Theory:

In system administration, automated logging is crucial for monitoring system performance, diagnosing issues, and maintaining records.
This experiment involves:

1. Logging details like username, date, processes, and disk usage.
2. Archiving old logs automatically.
3. Scheduling the script to run daily using `cron`.
4. Sending the daily log via local email to the system mailbox.

### Procedure & Observations

#### **Exercise 1: Creating the Daily Log Script**

##### **Task Statement:**

Write a shell script that logs system info, archives old logs, and emails the daily log.

##### **Explanation:**

This script:

* Identifies the current user.
* Creates a directory for storing logs.
* Saves daily logs with timestamps.
* Archives logs older than 7 days.
* Compresses weekly logs on Sundays.
* Sends the daily log via local email.
* Can be scheduled using a cron job.

##### **Command(s):**

```bash
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
    mail -s "Daily System Log - $(date +%Y-%m-%d)" tanmay@localhost < "$LOG_FILE"
    echo "Log emailed to local mailbox: tanmay@localhost"
else
    echo "No log file found for today!"
fi
```

Output:

<p align="center">
<img src="img/out1.png" width="900">
</p>

#### Exercise 2: Scheduling the Script

**Task Statement**:
Schedule the above script to run daily using cron.

**Explanation:**
Use crontab to automate the script execution at a fixed time every day.

Command(s):

```bash
crontab -e
0 8 * * * /home/tanmay/desktop/linux/exp3/midsem.sh
```

Output:

<p align="center">
<img src="img/out2.png" width="900">
</p>

**Final Output**:

<p align="center">
<img src="img/out3.png" width="900">
</p>



**Result**:
The script successfully logs daily system information, archives logs older than 7 days, compresses weekly logs, and emails the log locally. It runs daily via cron.

### **Conclusion:**

The Daily System Logger script automates log creation, archiving, weekly compression, and local email delivery. It successfully runs daily using cron, demonstrating practical use of shell scripting for system monitoring.

We can simply check the mail by typing mail and typing 1 if its the latest mail on our system., also all of these mails only exist on my system and not on the internet, So even though its sent via email it doesn’t go to gmail or the internet it stays on my system 
