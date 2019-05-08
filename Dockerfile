#
# docker run --rm -i "westonsteimel/jq" "$@"
#

FROM alpine:edge

RUN apk upgrade && apk --no-cache add jq \
    && rm -rf /var/cache/* \
    && addgroup jq \
    && adduser -G jq -s /bin/sh -D jq

USER jq

ENTRYPOINT ["jq"]
CMD ["--help"]
