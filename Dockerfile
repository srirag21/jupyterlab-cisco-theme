FROM continuumio/miniconda3

LABEL maintainer="Srinidhi Raghavendran srirag@cisco.com"

ARG http_proxy
ARG https_proxy

ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}

RUN apt-get update && apt-get install -y curl

COPY environment.yml /app/environment.yml

WORKDIR /app

RUN conda env create -f environment.yml
RUN echo "source activate jupyterlab_env" > ~/.bashrc

RUN /bin/bash -c "source activate jupyterlab_env && pip install -i https://test.pypi.org/simple/ cisco-theme-jupyter==1.0.0"

COPY overrides.json /app/overrides.json
RUN mkdir -p /opt/conda/envs/jupyterlab_env/share/jupyter/lab/settings \
    && cp /app/overrides.json /opt/conda/envs/jupyterlab_env/share/jupyter/lab/settings/overrides.json

COPY . /app/

RUN echo 'source /opt/conda/etc/profile.d/conda.sh' >> ~/.bashrc \
    && echo 'conda activate jupyterlab_env' >> ~/.bashrc

EXPOSE 8887

ENTRYPOINT ["/bin/bash", "-c", "source /opt/conda/etc/profile.d/conda.sh && conda activate jupyterlab_env && exec jupyter lab --ip=0.0.0.0 --port=8887 --allow-root --ServerApp.token='' --ServerApp.allow_origin='*' --ServerApp.allow_remote_access=True"]
