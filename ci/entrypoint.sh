#!/bin/sh
set -e

CONFIG_FILE="/app/config.yaml"
HTPASSWD_FILE="/app/.htpasswd"

# Check if config.yaml exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "⚠️ Config file not found! Exiting."
    exit 1
fi

# Function to replace placeholders in the config file
replace_placeholder() {
    local placeholder="$1"
    local value="$2"
    local description="$3"

    if [ -n "$value" ]; then
        echo "🔧 Setting $description..."
        sed -i "s|$placeholder|$value|g" "$CONFIG_FILE"
    else
        echo "⚠️ Warning: No $description set. Using default in config.yaml."
    fi
}

# Replace placeholders with environment variable values
replace_placeholder "DATABASE_CONNECTION_PLACEHOLDER" "$DATABASE_URL" "database connection string"
replace_placeholder "PASSWORD_PLACEHOLDER" "$PASSWORD" "password"
replace_placeholder "ADMIN_PLACEHOLDER" "$ADMIN" "admin username"
replace_placeholder "LCP_URL_PLACEHOLDER" "$LCP_URL" "LCP URL"
replace_placeholder "LSD_URL_PLACEHOLDER" "$LSD_URL" "LSD URL"
replace_placeholder "HINT_URL_PLACEHOLDER" "$HINT_URL" "Hint URL"

# Update .htpasswd file with ADMIN and PASSWORD environment variables
if [ -n "$ADMIN" ] && [ -n "$PASSWORD" ]; then
    echo "🔧 Updating .htpasswd file for user '$ADMIN'..."
    # Ensure the .htpasswd file exists
    touch "$HTPASSWD_FILE"
    # Add or update the user in the .htpasswd file
    htpasswd -bB "$HTPASSWD_FILE" "$ADMIN" "$PASSWORD"
    cat "$HTPASSWD_FILE"
else
    echo "⚠️ Warning: ADMIN and/or PASSWORD environment variables not set. Skipping .htpasswd update."
fi

# Show final config
echo "📝 Final config file:"
cat "$CONFIG_FILE"

# Run the main process
exec "$@"
