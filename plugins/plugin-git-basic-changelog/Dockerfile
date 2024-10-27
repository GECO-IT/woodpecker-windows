# syntax = docker/dockerfile:1
FROM alpine:3.20

LABEL architecture="x86_64" \
      maintainer="Geco-iT Team <contact@geco-it.fr>" \
      name="geco-it/woodpecker-teams-notify-plugin" \
      vendor="Geco-iT"

RUN apk -Uuv add --no-cache bash curl git

# Add script file
COPY git-log.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/git-log.sh

ENTRYPOINT ["/usr/local/bin/git-log.sh"]
