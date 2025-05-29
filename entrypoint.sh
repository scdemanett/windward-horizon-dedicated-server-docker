#!/bin/bash

# Define paths
SERVER_DIR="/home/windwardhorizon"

echo "Starting Windward Horizon server container..."
echo "Running initial setup as root..."

# Create directories if they don't exist
for dir in "$SERVER_DIR/Debug" "$SERVER_DIR/Players" "$SERVER_DIR/worlds"; do
    if [ ! -d "$dir" ]; then
        echo "Creating directory: $dir"
        mkdir -p "$dir"
    fi
done

# Try to make directories writable for windwardhorizon user
# This helps with volumes that might have restrictive permissions
echo "Setting permissions on directories..."
for dir in "$SERVER_DIR/Debug" "$SERVER_DIR/Players" "$SERVER_DIR/worlds"; do
    # Try to change ownership (this might fail on some mounted volumes)
    chown windwardhorizon:windwardhorizon "$dir" 2>/dev/null || true
    # Make directories writable
    chmod 755 "$dir" 2>/dev/null || true
done

# Check if server executable exists
if [ ! -f "$SERVER_DIR/WHServer.exe" ]; then
    echo "ERROR: WHServer.exe not found in $SERVER_DIR"
    echo "The server download may have failed during image build."
    exit 1
fi

# Ensure the windwardhorizon user owns the base directory and executables
chown windwardhorizon:windwardhorizon "$SERVER_DIR"
chown windwardhorizon:windwardhorizon "$SERVER_DIR"/*.exe 2>/dev/null || true
chown windwardhorizon:windwardhorizon "$SERVER_DIR"/*.dll 2>/dev/null || true

# Set default values if environment variables are not set
SERVER_NAME="${SERVER_NAME:-Windward Horizon Server}"
SERVER_PORT="${SERVER_PORT:-5137}"
WORLD_NAME="${WORLD_NAME:-Default World}"
PUBLIC_SERVER="${PUBLIC_SERVER:-true}"

# Build command
CMD="mono WHServer.exe -name \"$SERVER_NAME\" -tcp $SERVER_PORT -world \"$WORLD_NAME\" -service"

# Add -public flag if PUBLIC_SERVER is true
if [ "$PUBLIC_SERVER" = "true" ]; then
    CMD="$CMD -public"
fi

# Switch to server directory
cd "$SERVER_DIR"

# Run the server as windwardhorizon user
echo "Dropping privileges and starting server as windwardhorizon user..."
echo "Server Name: $SERVER_NAME"
echo "TCP Port: $SERVER_PORT"
echo "World: $WORLD_NAME"
echo "Public: $PUBLIC_SERVER"
echo "Command: $CMD"

# Use su to switch to windwardhorizon user and run the server
exec su -s /bin/bash windwardhorizon -c "$CMD"