FROM quay.io/spivegin/cockroach-builder AS build-env
WORKDIR /opt/golang/src/

RUN cd /opt/golang/src && mkdir -p /opt/golang/src/github.com/cockroachdb &&\
    cd /opt/golang/src/github.com/cockroachdb &&\
    git clone https://github.com/cockroachdb/cockroach.git &&\
    cd /opt/golang/src/github.com/cockroachdb/cockroach &&\
    make



FROM debian:stretch-slim
COPY --from=build-env /opt/golang/src/github.com/cockroachdb/cockroach /opt/cockroach
