# Miniconda base image
FROM continuumio/miniconda3:latest

# Set the maintainer label
LABEL maintainer="Srinidhi Raghavendran srirag@cisco.com"

# Switch to root to install packages
USER root

# Install any additional system packages that may be required
# RUN apt-get update && apt-get install -y <your-system-dependencies> && rm -rf /var/lib/apt/lists/*

# Create a Conda environment with JupyterLab and Node.js installed
RUN conda create -n cisco-theme-jupyter -c conda-forge nodejs jupyterlab=4 -y

# Activate the environment
ENV PATH /opt/conda/envs/cisco-theme-jupyter/bin:$PATH

# Install the Cisco theme from TestPyPI and network-centric Python libraries
RUN pip install -i https://test.pypi.org/simple/ cisco-theme-jupyter==1.0.0 && \
    pip install nornir netmiko napalm pyntc

    
# Copy any additional files, like certificates for SSL/TLS, resources, or configurations
# COPY ./certs /etc/ssl/certs/
# COPY ./resources /opt/conda/envs/cisco-theme-jupyter/lib/python3.*/site-packages/


# Set up volume for persistent storage
# VOLUME /opt/conda/envs/cisco-theme-jupyter/work

# Configure container startup
# CMD ["start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.password=''"]

# Expose the JupyterLab port
EXPOSE 8888

# Set the working directory to the JupyterLab work directory
# WORKDIR /opt/conda/envs/cisco-theme-jupyter/work

CMD ["sh", "-c", "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser & sleep 5 && jupyter notebook list | grep -oP 'http://127.0.0.1:8888/\\?token=\\K[^ ]+'"]
# CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token='your-predefined-token'"]
# Set the default command to run when starting the container
# CMD ["jupyter", "lab", "--ip='0.0.0.0'", "--port=8888", "--no-browser", \
#      "--NotebookApp.token='your-token-here'", "--NotebookApp.password=''", \
#      "--NotebookApp.allow_origin='*'", "--NotebookApp.base_url=/jupyter/"]

# configure a reverse proxy like Nginx to handle SSL/TLS termination and route traffic to the JupyterLab container securely.
