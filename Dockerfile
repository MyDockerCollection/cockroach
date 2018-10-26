FROM quay.io/spivegin/cockroach-builder:master AS build-env
WORKDIR /opt/src

RUN cd /opt/src && mkdir -p /opt/src/src/github.com/cockroachdb &&\
    cd /opt/src/src/github.com/cockroachdb &&\
    git clone https://github.com/cockroachdb/cockroach.git

RUN cd /opt/src/src/github.com/cockroachdb/cockroach &&\
    make && make build &&\
    mv cockroach cockroach.full &&\
    make build buildshort &&\
    mv cockroach cockroach.noui &&\
    make build buildoss &&\
    mv cockroach cockroach.oss &&\
    zip cockroach.zip cockroach.full cockroach.noui cockroach.oss 
    


FROM debian:stretch-slim

COPY --from=build-env /opt/src/src/github.com/cockroachdb/cockroach.zip /opt/cockroach.zip
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install zip unzip &&\
    cd /opt/ && upzip cockroach.zip && rm cockroach.oss cockroach.noui &&\
    chmod +x /opt/cockroach/cockroach.full && ln -s /opt/cockroach/cockroach.full /bin/cockroach &&\
    apt-get -y install libncurses5 && apt-get -y autoremove && apt-get -y clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*