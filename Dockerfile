FROM alpine
RUN apk -U upgrade && \
    apk add --no-cache bash \
        apache2 \
        curl \
        php5 \
        php5-apache2 \
        php5-bcmath \
        php5-bz2 \
        php5-calendar \
        php5-common \
        php5-ctype \
        php5-curl \
        php5-dom \
        php5-exif \
        php5-ftp \
        php5-gettext \
        php5-gd \
        php5-iconv \
        php5-intl \
        php5-imap \
        php5-json \
        php5-mailparse \
        php5-mysql \
        php5-mysqli \
        php5-mcrypt \
        php5-memcache \
        php5-opcache \
        php5-openssl \
        php5-pcntl \
        php5-pdo \
        php5-pdo_mysql \
        php5-pdo_pgsql \
        php5-pdo_sqlite \
        php5-phar \
        php5-posix \
        php5-pgsql \
        php5-shmop \
        php5-soap \
        php5-sockets \
        php5-sqlite3 \
        php5-sysvmsg \
        php5-sysvsem \
        php5-sysvshm \
        php5-wddx \
        php5-xml \
        php5-xmlreader \
        php5-xsl \
        php5-zip \
        php5-zlib \
        ca-certificates && \
    echo "http://dl-2.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    apk add --no-cache shadow && \
    rm -rf /var/cache/apk/* && \
    mkdir /run/apache2 && \
    groupmod -g 32 xfs && groupmod -g 33 www-data && usermod -u 106 -g www-data -G apache apache && \
    sed -ri \
        -e 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' \
        -e 's/#LoadModule\ remoteip_module/LoadModule\ remoteip_module/' \
        -e 's/#LoadModule\ expires_module/LoadModule\ expires_module/' \
        -e 's/#ServerName\ www.example.com/ServerName\ docker/' \
        -e 's/Group\ apache/Group\ www-data/' \
		-e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
		-e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
		"/etc/apache2/httpd.conf" && \
    printf "RemoteIPHeader X-Forwarded-For\nRemoteIPInternalProxy 172.31.0.0/16" > /etc/apache2/conf.d/remoteip.conf

COPY rootfs /
EXPOSE 80
RUN chmod a+x /start.sh
CMD ["/start.sh"]
