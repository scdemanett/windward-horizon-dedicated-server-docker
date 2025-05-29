FROM mono:6.12

# Install required packages
RUN apt-get update && \
    apt-get install -y wget unzip gosu && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN useradd -ms /bin/bash windwardhorizon

# Set working directory
WORKDIR /home/windwardhorizon

# Download and extract the Windward Horizon server files
RUN wget --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
         --timeout=30 \
         --tries=3 \
         -q \
         http://www.tasharen.com/wh/WHServer.zip -O WHServer.zip && \
    unzip -q WHServer.zip -d /home/windwardhorizon && \
    rm WHServer.zip && \
    chown -R windwardhorizon:windwardhorizon /home/windwardhorizon

# Create required directories
RUN mkdir -p /home/windwardhorizon/Debug && \
    mkdir -p /home/windwardhorizon/Players && \
    mkdir -p /home/windwardhorizon/worlds && \
    chown -R windwardhorizon:windwardhorizon /home/windwardhorizon

# Copy entrypoint script
COPY entrypoint.sh /home/windwardhorizon/entrypoint.sh

# Change the ownership and permissions of the entrypoint script
RUN chown windwardhorizon:windwardhorizon /home/windwardhorizon/entrypoint.sh && \
    chmod +x /home/windwardhorizon/entrypoint.sh

# Define environment variables with default values
ENV SERVER_NAME="Windward Horizon Server" \
    SERVER_PORT=5137 \
    WORLD_NAME="Default World" \
    PUBLIC_SERVER=true

# Expose the server port
EXPOSE ${SERVER_PORT}

# Volume mount points for worlds, player data, and debug logs
VOLUME ["/home/windwardhorizon/Debug", "/home/windwardhorizon/Players", "/home/windwardhorizon/worlds"]

# Command to run the entrypoint script
CMD ["bash", "/home/windwardhorizon/entrypoint.sh"]
