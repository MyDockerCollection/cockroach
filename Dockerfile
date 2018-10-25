FROM quay.io/spivegin/golangnodesj AS build-env
WORKDIR /opt/golang/src/

RUN apt-get update &&\
    apt-get -y install build-essential autoconf cmake libtinfo-dev libncurses5 libncurses5-dev

RUN cd /opt/src && mkdir -p /opt/src/src/github.com/cockroachdb &&\
    cd /opt/src/src/github.com/cockroachdb &&\
    git clone https://github.com/cockroachdb/cockroach.git

RUN cd /opt/src/src/github.com/cockroachdb/cockroach &&\
    make build


FROM debian:stretch-slim

COPY --from=build-env /opt/src/src/github.com/cockroachdb/cockroach /opt/cockroach
RUN apt-get -y update && apt-get -y upgrade && \
    chmod +x /opt/cockroach/cockroach && ln -s /opt/cockroach/cockroach /bin/cockroach &&\
    apt-get -y install libncurses5 && apt-get -y autoremove && apt-get -y clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*