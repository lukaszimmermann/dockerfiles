FROM alpine:3.7 as build

RUN apk update --no-cache --update-cache && \
    apk add    --no-cache --update-cache  \
      gcc \
      git \
      make \
      musl-dev
RUN mkdir -p /opt
RUN mkdir -p /tmp/build
WORKDIR /tmp/build
RUN git clone https://github.com/ongardie/diskbenchmark.git
WORKDIR /tmp/build/diskbenchmark
RUN make

## Production
FROM alpine:3.7 as prod
COPY --from=build /tmp/build/diskbenchmark/bench /opt/bin/bench
ENTRYPOINT [ "/opt/bin/bench" ]
