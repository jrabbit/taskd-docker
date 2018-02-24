FROM debian:stretch
MAINTAINER Jack Laxson <jackjrabbit@gmail.com>

COPY stretch-src.list /etc/apt/sources.list.d/

RUN apt-get update && apt-get build-dep -y taskd && apt install -y git gnutls-bin
	
RUN git clone --recursive https://github.com/jrabbit/taskserver.git /srv/taskserver &&\
	cd /srv/taskserver && git checkout debian-1.2 &&\
	tar -cJ --wildcards --exclude '.git*'  . > ../taskd_1.2.0.orig.tar.xz &&\ 
	dpkg-buildpackage -us -uc

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
