#!/bin/bash

# burnin_test.sh - Burn-in Test Script for Linux Servers

LOGFILE="/var/log/burnin_test_$(date +%F_%T).log"
DURATION=300  # Duration in seconds for each test

echo "==========================" | tee -a $LOGFILE
echo "🛠️ Burn-in Test Started: $(date)" | tee -a $LOGFILE
echo "Duration per test: $DURATION seconds" | tee -a $LOGFILE
echo "==========================" | tee -a $LOGFILE

# Function: Test CPU
test_cpu() {
    echo "🔥 CPU Stress Test..." | tee -a $LOGFILE
    stress-ng --cpu 4 --timeout $DURATION --metrics-brief | tee -a $LOGFILE
}

# Function: Test RAM
test_ram() {
    echo "🧠 Memory (RAM) Test..." | tee -a $LOGFILE
    stress-ng --vm 2 --vm-bytes 80% --timeout $DURATION --metrics-brief | tee -a $LOGFILE
}

# Function: Test Disk
test_disk() {
    TESTFILE="/tmp/burnin_testfile"
    echo "💽 Disk I/O Test (write/read/delete /tmp)..." | tee -a $LOGFILE
    dd if=/dev/zero of=$TESTFILE bs=1M count=1024 conv=fdatasync status=progress | tee -a $LOGFILE
    sync
    dd if=$TESTFILE of=/dev/null bs=1M status=progress | tee -a $LOGFILE
    rm -f $TESTFILE
}

# Function: Check Sensors
check_sensors() {
    echo "🌡️ Checking Temperature Sensors..." | tee -a $LOGFILE
    sensors | tee -a $LOGFILE
}

# Function: Check SMART
check_smart() {
    echo "📦 SMART Check on Disks..." | tee -a $LOGFILE
    for disk in $(lsblk -dno NAME); do
        echo "--- /dev/$disk ---" | tee -a $LOGFILE
        smartctl -H /dev/$disk | tee -a $LOGFILE
    done
}

# Ensure required tools are installed
check_tools() {
    for tool in stress-ng smartctl sensors dd; do
        if ! command -v $tool &>/dev/null; then
            echo "❌ Missing required tool: $tool. Please install it." | tee -a $LOGFILE
            exit 1
        fi
    done
}

# Main
check_tools
check_sensors
check_smart
test_cpu
test_ram
test_disk

echo "✅ Burn-in Test Completed at $(date)" | tee -a $LOGFILE
echo "📄 Log file saved to: $LOGFILE"
