FROM quay.io/spivegin/golangnodesj AS build-env
WORKDIR /opt/src/

RUN go get github.com/cockroachdb/cockroach && cd $GOPATH/src/github.com/cockroachdb/cockroach &&\
    make build && go build -o cockroach main.go 


FROM debian:stretch-slim
COPY --from=build-env /opt/src/github.com/cockroachdb/cockroach/cockroach /opt/cockroach
RUN chmod +x /opt/cockroach && ln -s /opt/cockroach /bin/cockroach
