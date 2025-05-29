# Windward Horizon Dedicated Server Docker

This Docker image runs a Windward Horizon dedicated server using Mono on Linux. The server executable is automatically downloaded during the image build process.

## Quick Start

### Build the image
```bash
docker build -t windward-horizon-dedicated-server .
```

### Run with default settings
```bash
docker run -d \
  -p 5127:5127 \
  -v /docker/windward-horizon/worlds:/home/windwardhorizon/worlds \
  windward-horizon-dedicated-server
```

### Run with custom settings
```bash
docker run -d \
  -p 5127:5127 \
  -e SERVER_NAME="My Custom Server" \
  -e SERVER_PORT=5127 \
  -e WORLD_NAME="My World" \
  -e PUBLIC_SERVER=true \
  -v /docker/windward-horizon/worlds:/home/windwardhorizon/worlds \
  windward-horizon-dedicated-server
```

## Environment Variables

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `SERVER_NAME`   | `Windward Horizon Server` | The name of your server as it appears in the server browser       |
| `SERVER_PORT`   | `5127`                    | The TCP port the server listens on                                |
| `WORLD_NAME`    | `Default World`           | The world filename WITHOUT the .world extension (e.g., for "Adventure.world" use "Adventure") |
| `PUBLIC_SERVER` | `true`                    | Whether the server appears in the public server list (true/false) |

## World File Configuration

**Important**: The `WORLD_NAME` variable should be the filename WITHOUT the `.world` extension:
- If your world file is named `New World.world`, set `WORLD_NAME="New World"`
- If your world file is named `Adventure.world`, set `WORLD_NAME="Adventure"`
- If your world file is named `MyServer.world`, set `WORLD_NAME="MyServer"`

## Docker Compose Example

A `docker-compose.yml` file is included as an example. This is optional and primarily useful for:
- Local testing
- Documentation of required settings
- Using as a Portainer Stack template

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  windward-server:
    build: .
    ports:
      - "5127:5127"
    environment:
      - SERVER_NAME=My Docker Server
      - SERVER_PORT=5127
      - WORLD_NAME=Adventure World    # For "Adventure World.world" file
      - PUBLIC_SERVER=true
    volumes:
      - /docker/windward-horizon/worlds:/home/windwardhorizon/worlds
    restart: unless-stopped
```

Then run:
```bash
docker-compose up -d
```

## Deployment Options

### Using Pre-built Images
If you're using a pre-built image from a registry (Docker Hub, GitHub Container Registry, etc.):

```bash
docker run -d \
  -p 5127:5127 \
  -e SERVER_NAME="My Server" \
  -e WORLD_NAME="MyWorld" \
  -v /path/to/worlds:/home/windwardhorizon/worlds \
  your-registry/windward-horizon-dedicated-server:latest
```

### Using Portainer
1. Pull the image in Portainer's Images section
2. Create a new container with:
   - Port mapping: 5127:5127
   - Environment variables as needed (remember WORLD_NAME is without .world extension)
   - Volume mapping for worlds directory
3. Or import the docker-compose.yml as a Stack

## Volume Mount

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `/docker/windward-horizon/worlds` | `/home/windwardhorizon/worlds` | World save files and player data |

The worlds volume is used to:
- Load existing world files (with .world extension)
- Save new worlds created by the server
- Store player data
- Persist all game data between container restarts

### Example with relative path:
```bash
docker run -d \
  -p 5127:5127 \
  -v $(pwd)/worlds:/home/windwardhorizon/worlds \
  windward-horizon-dedicated-server
```

## Notes

- The server runs using Mono runtime for .NET applications
- The server executable is automatically downloaded from the official source during image build
- World files should have the `.world` extension in the filesystem
- When specifying `WORLD_NAME`, use only the filename without the `.world` extension
- The server can create new worlds if none exist with the specified name
- The `-service` flag is automatically added for proper headless operation

## Special Thanks And Credit Where Credit Is Due

Special Thanks to MatureMindedGamers and their video [How to Setup Windward Horizon Dedicated Server (Complete Guide)](https://www.youtube.com/watch?v=PbTe7D1KTvI).

Steam Community Discussions around the dedicated server [Dedicated Server Setup Details](https://steamcommunity.com/app/2665460/discussions/0/599653352265001950/), [Server Executable](https://steamcommunity.com/app/2665460/discussions/0/560246502201600269/).

The [Tasharen Discord Server](http://discord.gg/tasharen) and discussions around running a Docker container with the dedicated server executable.

## Introduction

This repository contains the necessary files and instructions to run Windward Horizon as a dedicated server using Docker. This setup allows you to host a persistent game world that can be accessed by multiple players at different times.

## Prerequisites

- Docker
- Your world save files (optional - the server can create new worlds)

## Setup Instructions

### 1. Prepare World Files (Optional)

If you have existing world saves:
1. Create a directory for your worlds, e.g., `/docker/windward-horizon/worlds`
2. Copy your saved worlds from Windows: `%USERPROFILE%/Documents\Windward Horizon\Campaigns` to the worlds directory
3. Note the filename without the .world extension - you'll use this for the WORLD_NAME variable

### 2. Run the Server

The server executable is automatically included in the Docker image. Simply run the container with your desired configuration.