FROM quay.io/spivegin/cockroach-builder AS build-env
WORKDIR /opt/golang/src/
RUN apt-get update &&\
    apt-get -y install build-essential autoconf cmake libtinfo-dev libncurses-dev
RUN cd /opt/golang/src && mkdir -p /opt/golang/src/github.com/cockroachdb &&\
    cd /opt/golang/src/github.com/cockroachdb &&\
    git clone https://github.com/cockroachdb/cockroach.git &&\
    cd /opt/golang/src/github.com/cockroachdb/cockroach &&\
    make build

FROM debian:stretch-slim
COPY --from=build-env /opt/golang/src/github.com/cockroachdb/cockroach/cockroach /opt/cockroach
