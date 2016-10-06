#!/bin/bash

if [ ! -d "$TASKDDATA/pki/" ]; then
    echo "Woah there pardner don't try starting the server without certs!"
    echo "Mount the certs into /var/lib/taskd/pki"
    exit 301
fi

if [ ! -d "$TASKDDATA/orgs" ]; then
    taskd init --data $TASKDDATA && \
    taskd config --force client.cert $TASKDDATA/pki/client.cert.pem && \
    taskd config --force client.key $TASKDDATA/pki/client.key.pem && \
    taskd config --force server.cert $TASKDDATA/pki/server.cert.pem && \
    taskd config --force server.key $TASKDDATA/pki/server.key.pem && \
    taskd config --force server.crl $TASKDDATA/pki/server.crl.pem && \
    taskd config --force ca.cert $TASKDDATA/pki/ca.cert.pem && \
    taskd config server 0.0.0.0:53589 && \
    taskd config debug.tls 3 && \
    taskd config log /dev/stdout && \
    taskd add org Public

fi

exec taskd "$@"