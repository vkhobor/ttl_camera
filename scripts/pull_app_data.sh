#!/bin/bash

# Input Parameters
PACKAGE_NAME="$1"   # First argument: Package name of the app
LOCAL_DIR="$2"      # Second argument: Local directory for backup

# Validation for input arguments
if [ -z "$PACKAGE_NAME" ] || [ -z "$LOCAL_DIR" ]; then
    echo "Usage: $0 <package-name> <local-backup-dir>"
    exit 1
fi

# Generate a time-stamped temporary directory on the device
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")  # More human-readable timestamp
TEMP_DIR="/sdcard/Download/temp_app_data_${PACKAGE_NAME}_${TIMESTAMP}"

# Step 1: Create a temporary directory on the device
echo "Creating temporary directory on device: $TEMP_DIR"
adb shell "mkdir -p $TEMP_DIR"

# Step 2: Use run-as to copy app data to the temporary directory
echo "Copying app data to temporary directory..."
adb shell "
run-as $PACKAGE_NAME sh -c 'cp -r * $TEMP_DIR/'
"
if [ $? -ne 0 ]; then
    echo "Failed to access app data. Ensure the app is debuggable and try again."
    exit 1
fi

# Step 3: Pull data from the device to the local machine
echo "Copying data from device to local directory: $LOCAL_DIR"
mkdir -p "$LOCAL_DIR"
adb pull "$TEMP_DIR" "$LOCAL_DIR"

# Step 4: Cleanup the temporary directory on the device
echo "Cleaning up temporary directory on device..."
adb shell "rm -rf $TEMP_DIR"

echo "Data backup completed successfully. Files are located in $LOCAL_DIR"
