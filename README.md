# Windward Horizon Dedicated Server Docker

This Docker image runs a Windward Horizon dedicated server using Wine on Linux.

## Quick Start

### Build the image
```bash
docker build -t windward-horizon-dedicated-server .
```

### Run with default settings
```bash
docker run -d \
  -p 5127:5127 \
  -v /docker/windward-horizon/gamefiles:/home/windwardhorizon/gamefiles \
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
  -v /docker/windward-horizon/gamefiles:/home/windwardhorizon/gamefiles \
  -v /docker/windward-horizon/worlds:/home/windwardhorizon/worlds \
  windward-horizon-dedicated-server
```

## Environment Variables

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `SERVER_NAME`   | `Windward Horizon Server` | The name of your server as it appears in the server browser       |
| `SERVER_PORT`   | `5127`                    | The port the server listens on                                    |
| `WORLD_NAME`    | `Default World`           | The world file name to load                                       |
| `PUBLIC_SERVER` | `true`                    | Whether the server appears in the public server list (true/false) |

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
      - WORLD_NAME=Adventure World
      - PUBLIC_SERVER=true
    volumes:
      - /docker/windward-horizon/gamefiles:/home/windwardhorizon/gamefiles
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
  -v /path/to/gamefiles:/home/windwardhorizon/gamefiles \
  -v /path/to/worlds:/home/windwardhorizon/worlds \
  your-registry/windward-horizon-dedicated-server:latest
```

### Using Portainer
1. Pull the image in Portainer's Images section
2. Create a new container with:
   - Port mapping: 5127:5127
   - Environment variables as needed
   - Volume mappings for gamefiles and worlds
3. Or import the docker-compose.yml as a Stack

## Volume Mounts

The server requires two volume mounts:

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `/docker/windward-horizon/gamefiles` | `/home/windwardhorizon/gamefiles` | Dedicated server executable |
| `/docker/windward-horizon/worlds` | `/home/windwardhorizon/worlds` | World save files |

### Example with relative paths:
```bash
docker run -d \
  -p 5127:5127 \
  -v $(pwd)/gamefiles:/home/windwardhorizon/gamefiles \
  -v $(pwd)/worlds:/home/windwardhorizon/worlds \
  windward-horizon-dedicated-server
```

## Notes

- The server runs under Wine on Linux, which may have some performance overhead compared to native Windows
- The `WHServer.exe` file must be placed in the gamefiles volume directory before starting the container
- World files should be placed in the worlds volume directory
- The container will exit with an error if `WHServer.exe` is not found in the gamefiles directory

## Special Thanks And Credit Where Credit Is Due

Special Thanks to MatureMindedGamers and their video [How to Setup Windward Horizon Dedicated Server (Complete Guide)](https://www.youtube.com/watch?v=PbTe7D1KTvI).

Steam Community Discussions around the dedicated server [Dedicated Server Setup Details](https://steamcommunity.com/app/2665460/discussions/0/599653352265001950/), [Server Executable](https://steamcommunity.com/app/2665460/discussions/0/560246502201600269/)

## Introduction

This repository contains the necessary files and instructions to run Windward Horizon as a dedicated server using Docker. This setup allows you to host a persistent game world that can be accessed by multiple players at different times.

## Prerequisites

- Docker
- [Windward Horizon](https://store.steampowered.com/app/2665460/Windward_Horizon/) and the dedicated server executable from the [Tasharen Discord Server](http://discord.gg/tasharen) Direct Link for the [Windward Horizon Dedicated Server Executable](http://www.tasharen.com/wh/WHServer.zip)

## Setup Instructions

### 1. Prepare the Game Files

1. Download the dedicated server executable.
2. Setup directories to map for `gamefiles` and `worlds`. e.g. `/docker/windward-horizon/gamefiles` and `/docker/windward-horizon/worlds`
4. Transfer the game files (dedicated server executable) to your `gamefiles` directory e.g. `/docker/windward-horizon/gamefiles`.
5. Copy your saved world, found in Windows: `%USERPROFILE%/Documents\Windward Horizon\Campaigns` to the `worlds` directory.
6. Map network ports if necessary, the container is set to use port 5127 by default.