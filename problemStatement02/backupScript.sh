#!/bin/bash

# Configuration
SOURCE_DIR="/path/to/source_directory"
REMOTE_USER="remote_user"
REMOTE_HOST="remote_server"
REMOTE_DIR="/path/to/remote_directory"
LOG_FILE="/var/log/backup.log"
REPORT_EMAIL="your_email@example.com"

# Function to log messages
log_message() {
    local message=$1
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> $LOG_FILE
}

# Perform the backup using rsync
rsync -avz --delete "$SOURCE_DIR" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" &>> $LOG_FILE
if [ $? -eq 0 ]; then
    log_message "Backup successful."
    echo "Backup completed successfully on $(date)" | mail -s "Backup Success" $REPORT_EMAIL
else
    log_message "Backup failed."
    echo "Backup failed on $(date). Check the log file for details." | mail -s "Backup Failure" $REPORT_EMAIL
fi

