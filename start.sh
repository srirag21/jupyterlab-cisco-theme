#!/bin/bash

# Initialize Conda for the current shell session
source /opt/conda/etc/profile.d/conda.sh

# Activate the Conda environment
conda activate jupyterlab_env

# Start JupyterLab
exec jupyter lab --ip=0.0.0.0 --port=8887 --allow-root
