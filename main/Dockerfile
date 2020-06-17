#
# docker run --rm -i "westonsteimel/jq" "$@"
#

ARG JQ_VERSION="master"

FROM alpine:edge as builder

ARG JQ_VERSION

WORKDIR /build

RUN apk upgrade && apk --no-cache add \
    git \
    build-base \
    oniguruma-dev \
    automake \
    autoconf \
    libtool \
    flex-dev \
    bison

RUN git clone --depth 1 --branch "${JQ_VERSION}" "https://github.com/stedolan/jq" \
    && cd jq \
    && git submodule update --init \
    && autoreconf -fi \
    && ./configure \
	    --with-oniguruma=builtin \
        --disable-docs \
	&& make LDFLAGS=-all-static \
    && make install \
    && rm -rf /var/cache/* \
    && addgroup jq \
    && adduser -G jq -s /bin/sh -D jq

FROM scratch

ARG JQ_VERSION

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=builder /usr/local/bin/jq /usr/local/bin/jq

USER jq
WORKDIR /home/jq

ENTRYPOINT ["jq"]
CMD ["--help"]

LABEL org.opencontainers.image.title="jq" \
    org.opencontainers.image.description="jq in Docker" \ 
    org.opencontainers.image.url="https://github.com/westonsteimel/docker-jq" \ 
    org.opencontainers.image.source="https://github.com/westonsteimel/docker-jq" \
    org.opencontainers.image.version="${JQ_VERSION}" \
    version="${JQ_VERSION}"
