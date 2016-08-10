FROM debian:stretch
MAINTAINER Jack Laxson <jackjrabbit@gmail.com>

RUN apt-get update && apt-get install -y taskd gnutls-bin

ENV TASKDDATA=/var/lib/taskd

RUN taskd init --data /var/lib/taskd
# make config
RUN taskd config --force client.cert $TASKDDATA/pki/client.cert.pem && \
	taskd config --force client.key $TASKDDATA/pki/client.key.pem && \
	taskd config --force server.cert $TASKDDATA/pki/server.cert.pem && \
	taskd config --force server.key $TASKDDATA/pki/server.key.pem && \
	taskd config --force server.crl $TASKDDATA/pki/server.crl.pem && \
	taskd config --force ca.cert $TASKDDATA/pki/ca.cert.pem && \
	taskd config server 0.0.0.0:53589 && \
	taskd config debug.tls 3 && \
	taskd add org Public

# do it live
EXPOSE 53589

VOLUME /var/lib/taskd
WORKDIR /var/lib/taskd

# to find the volume: `docker inspect --format='{{.Volumes}}'`

CMD ["taskd", "server"]