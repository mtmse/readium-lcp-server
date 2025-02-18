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

if [ -n "$PASSWORD" ]; then
    echo "🔧 Setting database connection string..."
    sed -i "s|PASSWORD_PLACEHOLDER|$PASSWORD|" "$CONFIG_FILE"
else
    echo "⚠️ Warning: No PASSWORD set. Using default in config.yaml."
fi

if [ -n "$ADMIN" ]; then
    echo "🔧 Setting database connection string..."
    sed -i "s|ADMIN_PLACEHOLDER|$ADMIN|" "$CONFIG_FILE"
else
    echo "⚠️ Warning: No ADMIN set. Using default in config.yaml."
fi

if [ -n "$LCP_URL" ]; then
    echo "🔧 Setting database connection string..."
    sed -i "s|LCP_URL_PLACEHOLDER|$LCP_URL|" "$CONFIG_FILE"
else
    echo "⚠️ Warning: No LCP_URL set. Using default in config.yaml."
fi

if [ -n "$LSD_URL" ]; then
    echo "🔧 Setting database connection string..."
    sed -i "s|LSD_URL_PLACEHOLDER|$LSD_URL|" "$CONFIG_FILE"
else
    echo "⚠️ Warning: No LSD_URL set. Using default in config.yaml."
fi

if [ -n "$HINT_URL" ]; then
    echo "🔧 Setting database connection string..."
    sed -i "s|HINT_URL_PLACEHOLDER|$HINT_URL|" "$CONFIG_FILE"
else
    echo "⚠️ Warning: No HINT set. Using default in config.yaml."
fi

# Show final config
echo "📝 Final config file:"
cat "$CONFIG_FILE"

# Run the main process
exec "$@"
