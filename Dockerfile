#
# docker run --rm -i "westonsteimel/jq" "$@"
#

FROM alpine:edge

RUN apk upgrade && apk --no-cache add jq \
    && addgroup jq \
    && adduser -G jq -s /bin/sh -D jq

USER jq

ENTRYPOINT ["jq"]
CMD ["--help"]
