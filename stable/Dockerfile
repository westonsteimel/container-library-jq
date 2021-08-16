#
# docker run --rm -i "westonsteimel/jq" "$@"
#

ARG VERSION="1.6"
ARG REVISION="2e01ff1fb69609540b2bdc4e62a60499f2b2fb8e"

FROM alpine:latest as builder

ARG VERSION
ARG REVISION

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

RUN git clone --depth 1 --branch "jq-${VERSION}" "https://github.com/stedolan/jq" \
    && cd jq \
    && git reset --hard "${REVISION}" \
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

ARG VERSION
ARG REVISION
ENV JQ_VERSION="${VERSION}" \
    JQ_REVISION="${REVISION}"

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /usr/local/bin/jq /usr/local/bin/jq

USER jq
WORKDIR /home/jq

ENTRYPOINT ["jq"]
CMD ["--help"]

LABEL org.opencontainers.image.title="jq" \
    org.opencontainers.image.description="jq in Docker" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.version="${VERSION}"
    
