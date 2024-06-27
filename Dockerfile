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

# Copy the overrides.json file to a temporary location
COPY overrides.json /app/overrides.json

# Move the overrides.json file to the correct location using a RUN command
RUN JUPYTER_OVERRIDES_DIR=$(python -c 'import sys; print(f"{sys.prefix}/share/jupyter/lab/settings")') \
    && mkdir -p $JUPYTER_OVERRIDES_DIR \
    && mv /app/overrides.json $JUPYTER_OVERRIDES_DIR/overrides.json

# Copy the rest of the application code
COPY . /app/

# Ensure the start script is executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8888

ENTRYPOINT ["/app/start.sh"]
