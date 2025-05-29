FROM ubuntu:22.04

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and Wine with retry logic
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        wget \
        unzip \
        xvfb \
        ca-certificates \
        gnupg && \
    wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    add-apt-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' && \
    apt-get update && \
    apt-get install -y --install-recommends winehq-stable && \
    apt-get install -y winetricks && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN useradd -ms /bin/bash windwardhorizon

# Set working directory
WORKDIR /home/windwardhorizon

# Download and extract the Windward Horizon server files with retry
RUN for i in 1 2 3; do \
        wget -q http://www.tasharen.com/wh/WHServer.zip -O WHServer.zip && break || sleep 5; \
    done && \
    unzip WHServer.zip -d /home/windwardhorizon/server && \
    rm WHServer.zip && \
    chown -R windwardhorizon:windwardhorizon /home/windwardhorizon/server

# Create directory for worlds volume mount
RUN mkdir -p /home/windwardhorizon/worlds && \
    chown -R windwardhorizon:windwardhorizon /home/windwardhorizon

# Copy entrypoint script as root
COPY entrypoint.sh /home/windwardhorizon/entrypoint.sh

# Change the ownership and permissions of the entrypoint script
RUN chown windwardhorizon:windwardhorizon /home/windwardhorizon/entrypoint.sh && \
    chmod +x /home/windwardhorizon/entrypoint.sh

# Define environment variables with default values
ENV SERVER_NAME="Windward Horizon Server" \
    SERVER_PORT=5127 \
    WORLD_NAME="Default World" \
    PUBLIC_SERVER=true

# Expose the server port
EXPOSE ${SERVER_PORT}

# Volume mount point for worlds
VOLUME ["/home/windwardhorizon/worlds"]

# Switch to non-root user
USER windwardhorizon

# Command to run the entrypoint script
CMD ["bash", "/home/windwardhorizon/entrypoint.sh"]
