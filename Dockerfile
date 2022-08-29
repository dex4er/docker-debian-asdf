## $ docker build --tag debian-asdf:bullseye --squash .

ARG ASDF_RELEASE=v0.10.2
ARG DEBIAN_TAG=bullseye

FROM debian:${DEBIAN_TAG}

ARG ASDF_RELEASE

RUN apt-get -q -y update
RUN apt-get -q -y --no-install-recommends install \
  ca-certificates curl git unzip

WORKDIR /root/

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "${ASDF_RELEASE}"
RUN printf '\nsource /root/.asdf/asdf.sh\n' >> /root/.bashrc

RUN find /var/cache/apt /var/lib/apt/lists /var/log -type f -delete

ENV BASH_ENV=/root/.asdf/asdf.sh

RUN bash -c 'asdf info'
