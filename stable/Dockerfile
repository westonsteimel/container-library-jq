#
# docker run --rm -i "westonsteimel/jq" "$@"
#

ARG SOURCE
ARG REVISION
ARG CREATED
ARG VERSION
ARG GIT_REF="${VERSION}"

FROM alpine:latest as builder

ARG GIT_REF

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

RUN git clone --depth 1 --branch "${GIT_REF}" "https://github.com/stedolan/jq" \
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

ARG VERSION
ARG SOURCE
ARG REVISION
ARG CREATED

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=builder /usr/local/bin/jq /usr/local/bin/jq

USER jq
WORKDIR /home/jq

ENTRYPOINT ["jq"]
CMD ["--help"]

LABEL org.opencontainers.image.title="jq" \
    org.opencontainers.image.description="jq in Docker" \
    org.opencontainers.image.source="${SOURCE}" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.created="${CREATED}" \
    org.opencontainers.image.version="${VERSION}"
    
