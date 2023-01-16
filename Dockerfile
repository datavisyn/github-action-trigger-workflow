
FROM alpine:3.17.1

RUN apk update && \
    apk --no-cache add curl jq coreutils

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]
