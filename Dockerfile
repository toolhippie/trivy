FROM ghcr.io/dockhippie/golang:1.21 AS build

# renovate: datasource=github-releases depName=aquasecurity/trivy
ENV TRIVY_VERSION=0.54.0

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

FROM ghcr.io/dockhippie/alpine:3.20
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  apk add git rpm && \
  rm -rf /var/cache/apk/*

COPY --from=build /tmp/trivy /usr/bin/
