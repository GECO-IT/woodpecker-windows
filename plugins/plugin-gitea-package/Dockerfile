FROM curlimages/curl:8.9.1
LABEL org.opencontainers.image.authors="marco@ocram85.com"
#ENV PLUGIN_OWNER
#ENV PLUGIN_PACKAGE_NAME
#ENV PLUGIN_PACKAGE_VERSION
#ENV PLUGIN_FILE_NAME

#ENV PLUGIN_UPDATE
#ENV PLUGIN_DEBUG="1"
USER root
COPY --chown=100:101 --chmod=755 ./gitea-package.sh /app/gitea-package.sh
#RUN [ "chmod", "+x", "/app/gitea-package.sh" ]

USER curl_user

ENTRYPOINT [ "/app/gitea-package.sh" ]
