# jupyterhub_config.py
import os
import pwd
import subprocess

c = get_config()

c.JupyterHub.authenticator_class = "nativeauthenticator.NativeAuthenticator"
c.Authenticator.admin_users = {"admin"}
c.Authenticator.allow_all = True

# Use environment variables for IP and port
c.JupyterHub.port = int(os.environ.get("JUPYTERHUB_PORT", 8887))
c.JupyterHub.bind_url = "http://{}:{}".format(os.environ.get("JUPYTERHUB_IP", "0.0.0.0"), os.environ.get("JUPYTERHUB_PORT", 8887))

def pre_spawn_hook(spawner):
    username = spawner.user.name
    try:
        pwd.getpwnam(username)
    except KeyError:
        subprocess.check_call(["useradd", "-ms", "/bin/bash", username])

c.Spawner.pre_spawn_hook = pre_spawn_hook
c.Spawner.default_url = "/lab"
