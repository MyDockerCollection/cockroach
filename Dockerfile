FROM quay.io/spivegin/cockroach-builder AS build-env
WORKDIR /opt/src/

RUN cd /opt/src && mkdir -p /opt/src/github.com/cockroachdb &&\
    cd /opt/src/github.com/cockroachdb &&\
    git clone https://github.com/cockroachdb/cockroach.git &&\
    cd /opt/src/github.com/cockroachdb/cockroach &&\
    make build && ls -la


FROM debian:stretch-slim
COPY --from=build-env /opt/src/github.com/cockroachdb/cockroach/cockroach /opt/cockroach
RUN chmod +x /opt/cockroach && ln -s /opt/cockroach /bin/cockroach
