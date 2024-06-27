FROM continuumio/miniconda3

LABEL maintainer="Srinidhi Raghavendran srirag@cisco.com"

# Set up proxy environment variables if necessary
ARG http_proxy
ARG https_proxy

ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}

# Install curl and other necessary tools
RUN apt-get update && apt-get install -y curl

# Copy the environment.yml file and create the environment
COPY environment.yml /app/environment.yml

WORKDIR /app

RUN conda env create -f environment.yml
RUN echo "source activate jupyterlab_env" > ~/.bashrc

RUN /bin/bash -c "source activate jupyterlab_env && pip install -i https://test.pypi.org/simple/ cisco-theme-jupyter==1.0.0"

# Ensure the settings directory exists and copy the overrides.json file
COPY overrides.json /app/overrides.json
RUN mkdir -p /opt/conda/envs/jupyterlab_env/share/jupyter/lab/settings \
    && cp /app/overrides.json /opt/conda/envs/jupyterlab_env/share/jupyter/lab/settings/overrides.json

# Copy the rest of the application code
COPY . /app/

# Initialize Conda and activate the environment in the entrypoint
RUN echo 'source /opt/conda/etc/profile.d/conda.sh' >> ~/.bashrc \
    && echo 'conda activate jupyterlab_env' >> ~/.bashrc

EXPOSE 8888

# Start JupyterLab as the container entrypoint
ENTRYPOINT ["/bin/bash", "-c", "source /opt/conda/etc/profile.d/conda.sh && conda activate jupyterlab_env && exec jupyter lab --ip=0.0.0.0 --port=8887 --allow-root --ServerApp.token='' --ServerApp.allow_origin='*' --ServerApp.allow_remote_access=True"]
