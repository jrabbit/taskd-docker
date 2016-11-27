FROM debian:stretch
MAINTAINER Jack Laxson <jackjrabbit@gmail.com>

RUN apt-get update && apt-get install -y taskd gnutls-bin

ENV TASKDDATA=/var/lib/taskd


COPY entrypoint.sh /bin/

# do it live
EXPOSE 53589

VOLUME /var/lib/taskd
WORKDIR /var/lib/taskd

# to find the volume: `docker inspect --format='{{.Volumes}}'`
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["server"]
HEALTHCHECK CMD nc -z localhost 53589 || exit 1
