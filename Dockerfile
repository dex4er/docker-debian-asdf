## $ docker build --tag dex4er/debian-asdf --squash .

ARG ASDF_RELEASE=v0.10.2
ARG DEBIAN_TAG=bullseye
ARG VERSION=latest
ARG REVISION
ARG BUILDDATE

FROM debian:${DEBIAN_TAG}

ARG ASDF_RELEASE
ARG BUILDDATE
ARG VERSION
ARG REVISION

RUN apt-get -q -y update
RUN apt-get -q -y --no-install-recommends install \
  ca-certificates curl git procps unzip xz-utils

WORKDIR /root/

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "${ASDF_RELEASE}"
RUN printf '\nsource /root/.asdf/asdf.sh\n' >> /root/.bashrc

RUN find /var/cache/apt /var/lib/apt/lists /var/log -type f -delete

ENV ASDF_DIR=/root/.asdf
ENV PATH=/root/.asdf/shims:/root/.asdf/bin:${PATH}

RUN asdf info

LABEL \
  maintainer="Piotr Roszatycki <piotr.roszatycki@gmail.com>" \
  org.opencontainers.image.created=${BUILDDATE} \
  org.opencontainers.image.description="Container image with Debian and asdf" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.revision=${REVISION} \
  org.opencontainers.image.source=https://github.com/dex4er/docker-debian-asdf \
  org.opencontainers.image.title=debian-asdf \
  org.opencontainers.image.url=https://github.com/dex4er/docker-debian-asdf \
  org.opencontainers.image.vendor=dex4er \
  org.opencontainers.image.version=${VERSION}
