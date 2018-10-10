FROM jrabbit/gnutls:experimental AS build

RUN apt update && apt-get build-dep -y taskd && apt install -y git

RUN git clone --recursive https://github.com/jrabbit/taskserver.git /srv/taskserver &&\
        cd /srv/taskserver && git checkout debian-1.2 &&\
        tar -cJ --wildcards --exclude '.git*'  . > ../taskd_1.2.0.orig.tar.xz &&\
        dpkg-buildpackage -us -uc

FROM debian:experimental
COPY --from=build /srv/taskd_1.2.0-1_amd64.deb /srv/taskd_prebaked.deb
RUN apt update && apt install -y libgnutls30/experimental gnutls-bin/experimental lsb-base && apt clean
RUN dpkg -i /srv/taskd_prebaked.deb

ENV TASKDDATA=/var/lib/taskd
WORKDIR /var/lib/taskd
RUN rm config
COPY entrypoint.sh /bin/

ENV TAGNAME=v0.0.3
ADD https://github.com/jrabbit/taskd-client-go/releases/download/$TAGNAME/taskd-client /bin/
RUN chmod +x /bin/taskd-client

EXPOSE 53589
VOLUME /var/lib/taskd

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["server"]
HEALTHCHECK --interval=5m CMD taskd-client --norc --cacert pki/ca.cert.pem --certificate pki/client.cert.pem  --key pki/client.key.pem --insecure healthcheck