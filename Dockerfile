FROM ghcr.io/dockhippie/golang:1.20 AS build

# renovate: datasource=github-releases depName=aquasecurity/trivy
ENV TRIVY_VERSION=0.43.1

RUN git clone -b v${TRIVY_VERSION} https://github.com/aquasecurity/trivy.git /srv/app/src && \
  cd /srv/app/src && \
  GO111MODULE=on go install -ldflags "-X main.version=$(git describe --tags --abbrev=0)" ./cmd/trivy && \
  go clean ./...

FROM ghcr.io/dockhippie/alpine:3.18
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  apk add git rpm && \
  rm -rf /var/cache/apk/*

COPY --from=build /srv/app/bin/trivy /usr/bin/
