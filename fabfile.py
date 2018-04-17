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

@task
def push():
    local("docker push jrabbit/taskd:latest")

@task
def debug():
    local("gnutls-cli --x509keyfile pki/client.key.pem --x509certfile pki/client.cert.pem localhost -p 53589 --x509cafile ./pki/ca.cert.pem -r -V -d 99")
    local("openssl s_client -connect localhost:53589 -cert pki/client.cert.pem -key pki/client.key.pem -CAfile pki/ca.cert.pem")
