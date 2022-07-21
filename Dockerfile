FROM webhippie/golang:1.18 AS build

# renovate: datasource=github-tags depName=aquasecurity/trivy
ENV TRIVY_VERSION=v0.30.2

RUN git clone -b ${TRIVY_VERSION} https://github.com/aquasecurity/trivy.git /srv/app/src && \
  cd /srv/app/src && \
  GO111MODULE=on go install -ldflags "-X main.version=$(git describe --tags --abbrev=0)" ./cmd/trivy

FROM webhippie/alpine:3.16
ENTRYPOINT [""]

RUN apk update && \
  apk upgrade && \
  apk add git rpm && \
  rm -rf /var/cache/apk/*

COPY --from=build /srv/app/bin/trivy /usr/bin/
