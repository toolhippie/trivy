FROM ghcr.io/dockhippie/golang:1.23@sha256:8d1cff06bc3ad04ddc93f0b5346deb48d4079d4a69da49acb207c0c0010041f4 AS build

# renovate: datasource=github-releases depName=aquasecurity/trivy
ENV TRIVY_VERSION=0.67.2

ARG TARGETARCH

RUN case "${TARGETARCH}" in \
    'amd64') \
      curl -sSLo /tmp/trivy.tar.gz https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz; \
      ;; \
    'arm64') \
      curl -sSLo /tmp/trivy.tar.gz https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-ARM64.tar.gz; \
      ;; \
    'arm') \
      curl -sSLo /tmp/trivy.tar.gz https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-ARM.tar.gz; \
      ;; \
    *) echo >&2 "error: unsupported architecture '${TARGETARCH}'"; exit 1 ;; \
  esac && \
  cd /tmp && \
  tar xvzf trivy.tar.gz

FROM ghcr.io/dockhippie/alpine:3.22@sha256:c5bd9014e136d50a0d82c511a4fcf52a2ef43c55d9d535de035870845d1a98be
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  apk add git rpm && \
  rm -rf /var/cache/apk/*

COPY --from=build /tmp/trivy /usr/bin/
