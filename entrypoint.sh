#!/bin/bash

# Setup Wine prefix and directories
export WINEPREFIX=/home/windwardhorizon/.wine
export WINEARCH=win64

# Define paths
SERVER_DIR="/home/windwardhorizon/server"
WORLDS_DIR="/home/windwardhorizon/worlds"

# Check if server executable exists
if [ ! -f "$SERVER_DIR/WHServer.exe" ]; then
    echo "ERROR: WHServer.exe not found in $SERVER_DIR"
    echo "The server download may have failed during image build."
    exit 1
fi

# Initialize the Wine prefix
wine64 wineboot

# Install necessary components using winetricks
winetricks -q corefonts vcrun2017

# Ensure the directory structure for the game worlds
mkdir -p "$WINEPREFIX/drive_c/users/windwardhorizon/Documents/Windward Horizon/Campaigns"

# Link the worlds directory
ln -sf "$WORLDS_DIR" "$WINEPREFIX/drive_c/users/windwardhorizon/Documents/Windward Horizon/Campaigns"

# Navigate to the server directory
cd "$SERVER_DIR"

# Set default values if environment variables are not set
SERVER_NAME="${SERVER_NAME:-Windward Horizon Server}"
SERVER_PORT="${SERVER_PORT:-5127}"
WORLD_NAME="${WORLD_NAME:-Default World}"
PUBLIC_SERVER="${PUBLIC_SERVER:-true}"

# Build command arguments
CMD_ARGS="-name \"$SERVER_NAME\" -port $SERVER_PORT -world \"$WORLD_NAME\""

# Add -public flag if PUBLIC_SERVER is true
if [ "$PUBLIC_SERVER" = "true" ]; then
    CMD_ARGS="$CMD_ARGS -public"
fi

# Run the game using Wine in headless mode with xvfb
echo "Starting Windward Horizon server with arguments: $CMD_ARGS"
xvfb-run -a wine64 "WHServer.exe" $CMD_ARGS