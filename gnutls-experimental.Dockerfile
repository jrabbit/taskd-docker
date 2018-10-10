FROM debian:experimental
ADD gnutls-dev-srcs.list /etc/apt/sources.list.d/
WORKDIR /srv
RUN apt update && apt install -y libgnutls28-dev/experimental gnutls-bin/experimental
