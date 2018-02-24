from fabric.api import *

@task
def deps():
    local("docker pull debian:stretch")

@task
def build():
    local("docker build -t jrabbit/taskd . --no-cache")

@task
def outdated():
    local("docker run -it --rm --entrypoint bash jrabbit/taskd -c 'apt-get update && apt list --upgradable' ")

@task
def auto():
    deps()
    build()
