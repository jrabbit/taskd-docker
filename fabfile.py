from fabric.api import *

@task
def deps():
    local("docker pull debian:stretch")

@task
def build():
    local("docker build -t jrabbit/taskd . --no-cache")

@task
def auto():
    deps()
    build()
