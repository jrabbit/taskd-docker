# taskd-docker


This image/dockerfile is based on debian & [debian's taskd](https://packages.debian.org/stretch/taskd). You won't need to build taskd from source if you modify this dockerfile. We also have a robust HEALTHCHECK thanks to https://github.com/jrabbit/taskd-client-go

# PKI

This is still all on you.

Mount your certs to /var/lib/taskd/pki

Use taskd's 1.2 sources for pki-scripts.