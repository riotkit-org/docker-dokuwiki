ARG VERSION
ARG FROM_IMAGE

FROM $FROM_IMAGE

ARG VERSION

LABEL maintainer="RiotKit" \
  org.label-schema.name="dokuwiki" \
  org.label-schema.description="DokuWiki" \
  org.label-schema.url="https://github.com/riotkit-org" \
  org.label-schema.vcs-url="https://github.com/riotkit-org/docker-dokuwiki" \
  org.label-schema.vendor="RiotKit" \
  org.label-schema.version="$VERSION"

ENV NGINX_ENABLE_DEFAULT_LOCATION_INDEX=false \
    WWW_USER_ID=1000 \
    WWW_GROUP_ID=1000 \
    DOKUWIKI_VERSION=$VERSION \
    DOKUWIKI_INSTALL=false

ADD application.tar.gz /var/www/html/
ADD entrypoint.d/* /entrypoint.d/

RUN cd /var/www/html \
    && mv ./*dokuwiki-*/* ./ \
    && chown www-data:www-data /var/www/html \
    && test -f index.php \
    && test -f doku.php \
    && test -d data \
    \
    && mkdir -p /template \
    && mv /var/www/html/lib /template/lib \
    && mv /var/www/html/data /template/data \
    && mv /var/www/html/conf /template/conf

COPY etc/nginx/conf.d/* /.etc.template/nginx/conf.d/
