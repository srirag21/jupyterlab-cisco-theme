#!/bin/bash

stop_existing_containers() {
    echo "Checking for containers using port 8000..."
    containers=$(docker ps -q --filter "publish=8000")

    if [ -n "$containers" ]; then
        echo "Stopping and removing the following containers:"
        echo "$containers"
        docker stop $containers
        docker rm $containers
    else
        echo "No containers using port 8000."
    fi
}

stop_existing_containers

docker build --build-arg http_proxy=http://proxy-wsa.esl.cisco.com:80 \
             --build-arg https_proxy=http://proxy-wsa.esl.cisco.com:80 \
             -t cisco_theme_jupyter .

if [ $? -eq 0 ]; then
    echo "Docker image built successfully."

    NOTEBOOKS_DIR=$(pwd)/notebooks
    mkdir -p $NOTEBOOKS_DIR

    container_id=$(docker run -d -p 8000:8000 -v $NOTEBOOKS_DIR:/app/notebooks cisco_theme_jupyter)

    if [ $? -eq 0 ]; then
        echo "Docker container started successfully."
        
        sleep 5

        echo "You can access your environment at http://127.0.0.1:8000"
    else
        echo "Failed to start Docker container."
    fi
else
    echo "Failed to build Docker image."
fi
