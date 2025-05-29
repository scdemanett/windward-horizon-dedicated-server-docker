FROM ubuntu:20.04

# Install necessary packages and Wine
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y software-properties-common wget unzip xvfb && \
    apt-get install -y wine64 wine32 libwine libmono-cil-dev winetricks && \
    rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN useradd -ms /bin/bash windwardhorizon

# Set working directory
WORKDIR /home/windwardhorizon

# Create directories for volume mounts
RUN mkdir -p /home/windwardhorizon/gamefiles /home/windwardhorizon/worlds && \
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

# Volume mount points
VOLUME ["/home/windwardhorizon/gamefiles", "/home/windwardhorizon/worlds"]

# Switch to non-root user
USER windwardhorizon

# Command to run the entrypoint script
CMD ["bash", "/home/windwardhorizon/entrypoint.sh"]
