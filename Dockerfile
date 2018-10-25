FROM quay.io/spivegin/golangnodesj AS build-env
WORKDIR /opt/golang/src/

RUN apt-get update &&\
    apt-get -y install build-essential autoconf cmake libtinfo-dev libncurses-dev

RUN cd /opt/src && mkdir -p /opt/src/src/github.com/cockroachdb &&\
    cd /opt/src/src/github.com/cockroachdb &&\
    git clone https://github.com/cockroachdb/cockroach.git

RUN cd /opt/src/src/github.com/cockroachdb/cockroach &&\
    make build


FROM debian:stretch-slim
COPY --from=build-env /opt/src/src/github.com/cockroachdb/cockroach/cockroach /opt/cockroach
RUN chmod +x /opt/cockroach && ln -s /opt/cockroach /bin/cockroach
