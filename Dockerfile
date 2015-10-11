FROM debian:latest
MAINTAINER Jack Laxson <jackjrabbit@gmail.com>

#Depends: libc6 (>= 2.14), libgcc1 (>= 1:4.1.1), libgnutls-deb0-28 (>= 3.3.0), libstdc++6 (>= 4.9), libuuid1 (>= 2.16)
RUN apt-get update && apt-get install -y libc6 libgcc1 libgnutls-deb0-28 libstdc++6 libuuid1 init-system-helpers 

#Technically optional
# gnutls for cert gen unless you want to hand install them for clients
RUN apt-get install -y gnutls-bin

#TODO: change to gpg verification
ADD http://jack.stdnt.hampshire.edu/taskd_1.1.0-1_amd64.deb /tmp/taskd_1.1.0-1_amd64.deb
RUN echo "dc2b720c2f67addadf8c15f25819e09e4be11eb7 */tmp/taskd_1.1.0-1_amd64.deb" | sha1sum -c - && dpkg -i /tmp/taskd_1.1.0-1_amd64.deb


# Do the certs
COPY pki/*.pem /var/lib/taskd/

ENV TASKDDATA=/var/lib/taskd

RUN taskd init --data /var/lib/taskd
# make config
RUN taskd config --force client.cert $TASKDDATA/client.cert.pem && \
    taskd config --force client.key $TASKDDATA/client.key.pem && \
    taskd config --force server.cert $TASKDDATA/server.cert.pem && \
    taskd config --force server.key $TASKDDATA/server.key.pem && \
    taskd config --force server.crl $TASKDDATA/server.crl.pem && \
    taskd config --force ca.cert $TASKDDATA/ca.cert.pem && \
    taskd config server 0.0.0.0:53589 && \
    taskd config debug.tls 3 && \
    taskd add org Public

# do it live
EXPOSE 53589

VOLUME /var/lib/taskd

# to find the volume: `docker inspect --format='{{.Volumes}}'`

CMD taskd server