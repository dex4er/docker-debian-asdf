# docker-debian-asdf

[![GitHub](https://img.shields.io/github/v/tag/dex4er/docker-debian-asdf?label=GitHub)](https://github.com/dex4er/docker-debian-asdf)
[![CI](https://github.com/dex4er/docker-debian-asdf/actions/workflows/ci.yaml/badge.svg)](https://github.com/dex4er/docker-debian-asdf/actions/workflows/ci.yaml)
[![Lint](https://github.com/dex4er/docker-debian-asdf/actions/workflows/lint.yaml/badge.svg)](https://github.com/dex4er/docker-debian-asdf/actions/workflows/lint.yaml)
[![Docker Image Version](https://img.shields.io/docker/v/dex4er/debian-asdf/latest?label=docker&logo=docker)](https://hub.docker.com/r/dex4er/debian-asdf)

Container image with [asdf](https://asdf-vm.com/) installer.

## Tags

- `bullseye-YYYYmmdd-asdf-X.Y.Z`, `latest`

## Usage

CLI:

```shell
docker pull dex4er/debian-asdf
docker run dex4er/debian-asdf bash -c "asdf plugin add nodejs && asdf install nodejs latest && asdf global nodejs latest && node -v"
```

Dockerfile:

```Dockerfile
FROM dex4er/debian-asdf:latest
COPY .tool-versions /root/
RUN bash -c 'cat .tool-versions | while read plugin version; do asdf plugin add $plugin; done'
RUN bash -c 'asdf install'
RUN bash -c 'asdf list'
```

## License

[License information](https://github.com/asdf-vm/asdf/blob/master/LICENSE) for
[asdf](https://asdf-vm.com/) project.

[License
information](https://github.com/dex4er/docker-debian-asdf/blob/main/LICENSE) for
container image project.
