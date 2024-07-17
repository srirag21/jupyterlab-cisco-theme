FROM continuumio/miniconda3

LABEL maintainer="Srinidhi Raghavendran srirag@cisco.com"

ARG http_proxy
ARG https_proxy

ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}
ENV JUPYTERHUB_IP=100.0.0.0
ENV JUPYTERHUB_PORT=87

RUN apt-get update && apt-get install -y curl

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN echo "Node: " && node -v
RUN echo "NPM: " && npm -v
RUN npm install -g configurable-http-proxy

COPY environment.yml /app/environment.yml

WORKDIR /app

RUN conda env create -f environment.yml
RUN echo "source activate jupyterlab_env" >> ~/.bashrc

RUN /bin/bash -c "source activate jupyterlab_env && \
    pip install jupyterhub notebook"

RUN /bin/bash -c "source activate jupyterlab_env && pip install -i https://test.pypi.org/simple/ cisco-theme-jupyter==1.0.1"
RUN /bin/bash -c "source activate jupyterlab_env && \
    conda install -c conda-forge jupyterhub notebook jupyterlab"
RUN git clone https://github.com/jupyterhub/nativeauthenticator.git /home/nativeauthenticator
RUN /bin/bash -c "source activate jupyterlab_env && \
    pip install -e /home/nativeauthenticator"

COPY jupyterhub_config.py /etc/jupyterhub/jupyterhub_config.py

COPY overrides.json /app/overrides.json
RUN mkdir -p /opt/conda/envs/jupyterlab_env/share/jupyter/lab/settings \
    && cp /app/overrides.json /opt/conda/envs/jupyterlab_env/share/jupyter/lab/settings/overrides.json

COPY . /app/

EXPOSE 87

CMD ["/bin/bash", "-c", "source /opt/conda/etc/profile.d/conda.sh && conda activate jupyterlab_env && exec jupyterhub -f /etc/jupyterhub/jupyterhub_config.py"]
