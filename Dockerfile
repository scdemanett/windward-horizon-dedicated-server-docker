FROM mono:6.12

# Install required packages
RUN apt-get update && \
    apt-get install -y wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN useradd -ms /bin/bash windwardhorizon

# Set working directory
WORKDIR /home/windwardhorizon

# Download and extract the Windward Horizon server files
RUN wget -q http://www.tasharen.com/wh/WHServer.zip -O WHServer.zip && \
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
