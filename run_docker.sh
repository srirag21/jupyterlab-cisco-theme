#!/bin/bash

# Function to check and stop any containers using port 8888
stop_existing_containers() {
    echo "Checking for containers using port 8887..."
    containers=$(docker ps -q --filter "publish=8887")

    if [ -n "$containers" ]; then
        echo "Stopping and removing the following containers:"
        echo "$containers"
        docker stop $containers
        docker rm $containers
    else
        echo "No containers using port 8887."
    fi
}

# Check and stop existing containers
stop_existing_containers

# Build the Docker image with proxy settings
docker build --build-arg http_proxy=http://proxy-wsa.esl.cisco.com:80 \
             --build-arg https_proxy=http://proxy-wsa.esl.cisco.com:80 \
             -t cisco_theme_jupyter .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image built successfully."

    # Run the Docker container with the --no-browser flag
    docker run -p 8887:8887 cisco_theme_jupyter jupyter lab --ip=0.0.0.0 --port=8887 --allow-root --no-browser

    # Check if the container started successfully
    if [ $? -eq 0 ]; then
        echo "Docker container started successfully."
        echo "Access JupyterLab at http://<your-docker-host-ip>:8887"
    else
        echo "Failed to start Docker container."
    fi
else
    echo "Failed to build Docker image."
fi
 