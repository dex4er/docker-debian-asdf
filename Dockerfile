## $ docker buildx build --platform=linux/amd64 --tag dex4er/debian-asdf .

ARG ASDF_RELEASE=v0.13.1
ARG DEBIAN_TAG=bullseye
ARG VERSION=latest
ARG REVISION
ARG BUILDDATE

FROM debian:${DEBIAN_TAG} as build

ARG ASDF_RELEASE

RUN apt-get -q -y update
RUN apt-get -q -y --no-install-recommends install \
  ca-certificates curl git make procps unzip xz-utils

WORKDIR /root/

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "${ASDF_RELEASE}"
RUN printf '\nsource /root/.asdf/asdf.sh\n' >> /root/.bashrc

RUN find /var/cache/apt /var/lib/apt/lists /var/log -type f -delete


FROM scratch

ARG BUILDDATE
ARG VERSION
ARG REVISION

COPY --from=build / /

ENV ASDF_DIR=/root/.asdf
ENV PATH=/root/.asdf/shims:/root/.asdf/bin:${PATH}

RUN asdf info

CMD [ "bash" ]

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
