#!/bin/bash
echo "Running preconfigure_notebooks.sh for user: $1"

USERNAME=$1
USER_DIR="/home/jovyan/$USERNAME"
NOTEBOOKS_DIR="/app/notebooks"

echo "Creating user directory: $USER_DIR"
if [ ! -d "$USER_DIR" ]; then
    mkdir -p "$USER_DIR"
    echo "Copying notebooks to $USER_DIR"
    cp -r $NOTEBOOKS_DIR/* $USER_DIR/
    echo "Changing ownership of $USER_DIR"
    chown -R jovyan:users $USER_DIR
else
    echo "User directory $USER_DIR already exists"
fi
