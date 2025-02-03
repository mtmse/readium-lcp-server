#!/bin/sh
set -e

CONFIG_FILE="/app/config.yaml"

# Check if config.yaml exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "⚠️ Config file not found! Exiting."
    exit 1
fi

# Replace database connection string if environment variable is set
if [ -n "$DATABASE_URL" ]; then
    echo "🔧 Setting database connection string..."
    sed -i "s|DATABASE_CONNECTION_PLACEHOLDER|$DATABASE_URL|" "$CONFIG_FILE"
else
    echo "⚠️ Warning: No DATABASE_URL set. Using default in config.yaml."
fi

# Show final config
echo "📝 Final config file:"
cat "$CONFIG_FILE"

# Run the main process
exec "$@"
