#!/bin/bash

# Activate the Conda environment
source activate jupyterlab_env

# Start JupyterLab
exec jupyter lab --ip=0.0.0.0 --port=8887 --allow-root --no-browser