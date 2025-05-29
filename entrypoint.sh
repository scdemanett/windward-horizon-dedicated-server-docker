#!/bin/bash

# Define paths
SERVER_DIR="/home/windwardhorizon"

# Check if server executable exists
if [ ! -f "$SERVER_DIR/WHServer.exe" ]; then
    echo "ERROR: WHServer.exe not found in $SERVER_DIR"
    echo "The server download may have failed during image build."
    exit 1
fi

# Navigate to the server directory
cd "$SERVER_DIR"

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

# Run the server
echo "Starting Windward Horizon server..."
echo "Server Name: $SERVER_NAME"
echo "TCP Port: $SERVER_PORT"
echo "World: $WORLD_NAME"
echo "Public: $PUBLIC_SERVER"
echo "Command: $CMD"

eval $CMD