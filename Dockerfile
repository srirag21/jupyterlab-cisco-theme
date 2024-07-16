FROM continuumio/miniconda3

LABEL maintainer="Srinidhi Raghavendran srirag@cisco.com"

ARG http_proxy
ARG https_proxy

ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}

RUN apt-get update && apt-get install -y curl

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN echo "Node: " && node -v
RUN echo "NPM: " && npm -v
RUN npm install -g configurable-http-proxy

COPY environment.yml /app/environment.yml

WORKDIR /app

RUN conda env create -f environment.yml
RUN echo "source activate jupyterlab_env" > ~/.bashrc

RUN /bin/bash -c "source activate jupyterlab_env && \
    pip install jupyterhub notebook"

RUN /bin/bash -c "source activate jupyterlab_env && pip install -i https://test.pypi.org/simple/ cisco-theme-jupyter==1.0.1"
RUN /bin/bash -c "source activate jupyterlab_env && \
    conda install -c conda-forge jupyterhub notebook jupyterlab"
RUN git clone https://github.com/jupyterhub/nativeauthenticator.git /home/nativeauthenticator
RUN /bin/bash -c "source activate jupyterlab_env && \
    pip install -e /home/nativeauthenticator"


RUN mkdir /etc/jupyterhub && \
/bin/bash -c "source activate jupyterlab_env && \
jupyterhub --generate-config -f /etc/jupyterhub/jupyterhub_config.py"
RUN echo 'import pwd, subprocess\n\
c.JupyterHub.authenticator_class = "nativeauthenticator.NativeAuthenticator"\n\
c.Authenticator.admin_users = {"admin"}\n\
c.Authenticator.allow_all = True\n\
c.JupyterHub.port = 8887\n\
c.JupyterHub.bind_url = "http://:8887"\n\
def pre_spawn_hook(spawner):\n\
    username = spawner.user.name\n\
    try: pwd.getpwnam(username)\n\
    except KeyError: subprocess.check_call(["useradd", "-ms", "/bin/bash", username])\n\
c.Spawner.pre_spawn_hook = pre_spawn_hook\n\
c.Spawner.default_url = "/lab"\n' \
>> /etc/jupyterhub/jupyterhub_config.py

COPY overrides.json /app/overrides.json
RUN mkdir -p /opt/conda/envs/jupyterlab_env/share/jupyter/lab/settings \
    && cp /app/overrides.json /opt/conda/envs/jupyterlab_env/share/jupyter/lab/settings/overrides.json

COPY . /app/

EXPOSE 8887

ENTRYPOINT ["/bin/bash", "-c", "unset http_proxy && unset https_proxy && source /opt/conda/etc/profile.d/conda.sh && \
    source activate jupyterlab_env && \
    exec jupyterhub -f /etc/jupyterhub/jupyterhub_config.py --ip=0.0.0.0 --port=8887 --no-ssl\
    >> /var/log/jupyterhub.log 2>&1"]
