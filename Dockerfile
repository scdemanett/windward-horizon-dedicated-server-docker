FROM mono:6.12

# Install required packages
RUN apt-get update && \
    apt-get install -y wget unzip curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN useradd -ms /bin/bash windwardhorizon

# Set working directory
WORKDIR /home/windwardhorizon

# Download and extract the Windward Horizon server files with retry logic
RUN echo "Attempting to download WHServer.zip..." && \
    for i in 1 2 3 4 5; do \
        echo "Download attempt $i..." && \
        wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
             --no-check-certificate \
             --timeout=30 \
             --tries=3 \
             --debug \
             http://www.tasharen.com/wh/WHServer.zip -O WHServer.zip && \
        echo "Download successful" && \
        break || \
        (echo "wget failed, trying curl..." && \
         curl -L -o WHServer.zip \
              -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
              --connect-timeout 30 \
              --max-time 300 \
              http://www.tasharen.com/wh/WHServer.zip && \
         echo "Curl download successful" && \
         break) || \
        (echo "Both wget and curl failed on attempt $i, retrying in 10 seconds..." && sleep 10); \
    done && \
    if [ ! -f WHServer.zip ]; then \
        echo "ERROR: Failed to download WHServer.zip after 5 attempts"; \
        echo "The file may have been moved or the server may be blocking GitHub Actions."; \
        exit 1; \
    fi && \
    echo "Verifying downloaded file..." && \
    ls -la WHServer.zip && \
    unzip WHServer.zip -d /home/windwardhorizon && \
    rm WHServer.zip && \
    chown -R windwardhorizon:windwardhorizon /home/windwardhorizon

# Create required directories
RUN mkdir -p /home/windwardhorizon/Players/Debug && \
    mkdir -p /home/windwardhorizon/worlds && \
    chown -R windwardhorizon:windwardhorizon /home/windwardhorizon

# Copy entrypoint script
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

# Volume mount point for worlds and player data
VOLUME ["/home/windwardhorizon/worlds"]

# Switch to non-root user
USER windwardhorizon

# Command to run the entrypoint script
CMD ["bash", "/home/windwardhorizon/entrypoint.sh"]
