#!/bin/sh

# Start the appropriate server
if [ "$SERVER_TYPE" = "LCP" ]; then
    echo "Starting LCP server..."
    exec /app/bin/lcpserver --https --cert /etc/ssl/lcpserver.crt --key /etc/ssl/lcpserver.key
elif [ "$SERVER_TYPE" = "LSD" ]; then
    echo "Starting LSD server..."
    exec /app/bin/lsdserver --https --cert /etc/ssl/lsdserver.crt --key /etc/ssl/lsdserver.key
else
    echo "SERVER_TYPE not set or invalid. Exiting."
    exit 1
fi

# Mount BlobFuse2
echo "Mounting BlobFuse2..."
blobfuse2 mount /data/files --config-file=/etc/blobfuse2.yaml

# Check if BlobFuse2 mount succeeded
if [ $? -ne 0 ]; then
    echo "BlobFuse2 mount failed!"
    exit 1
fi