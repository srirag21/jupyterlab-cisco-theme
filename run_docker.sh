#!/bin/bash

# Function to check and stop any containers using port 8887
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

    # Define a volume mount for notebooks
    NOTEBOOKS_DIR=$(pwd)/notebooks
    mkdir -p $NOTEBOOKS_DIR

    # Run the Docker container with the volume mount
    container_id=$(docker run -d -p 8887:8887 -v $NOTEBOOKS_DIR:/app/notebooks cisco_theme_jupyter)

    # Check if the container started successfully
    if [ $? -eq 0 ]; then
        echo "Docker container started successfully."
        
        # Wait a few seconds to ensure JupyterLab is up and running
        sleep 5

        # Open the browser (for MacOS use 'open', for Linux use 'xdg-open', for Windows use 'start')
        if command -v open &> /dev/null
        then
            open http://127.0.0.1:8887  # MacOS
        elif command -v xdg-open &> /dev/null
        then
            xdg-open http://127.0.0.1:8887  # Linux
        elif command -v start &> /dev/null
        then
            start http://127.0.0.1:8887  # Windows
        else
            echo "No supported browser opening command found."
        fi
    else
        echo "Failed to start Docker container."
    fi
else
    echo "Failed to build Docker image."
fi
