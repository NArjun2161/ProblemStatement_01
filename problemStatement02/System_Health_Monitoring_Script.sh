#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=90

# Define log file
LOG_FILE="/var/log/system_health_monitor.log"

# Function to log messages
log_message() {
    local message=$1
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> $LOG_FILE
}

# Check CPU usage
cpu_usage=$(mpstat 1 1 | awk '/Average:/ {print 100 - $12}')
if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
    log_message "CPU usage is above threshold: $cpu_usage%"
fi

# Check memory usage
memory_usage=$(free | awk '/Mem:/ {print $3/$2 * 100.0}')
if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
    log_message "Memory usage is above threshold: $memory_usage%"
fi

# Check disk space usage
disk_usage=$(df / | awk '/\/$/ {print $5}' | sed 's/%//')
if (( disk_usage > DISK_THRESHOLD )); then
    log_message "Disk space usage is above threshold: $disk_usage%"
fi

# Check running processes
high_cpu_processes=$(ps -eo pid,comm,%cpu --sort=-%cpu | awk '$3 > 50 {print $0}')
if [[ ! -z "$high_cpu_processes" ]]; then
    log_message "High CPU usage processes:\n$high_cpu_processes"
fi

# Check if log file exists, create it if it doesn't
if [[ ! -f $LOG_FILE ]]; then
    touch $LOG_FILE
    chmod 644 $LOG_FILE
fi

