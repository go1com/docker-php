FROM alpine
MAINTAINER sang@go1.com.au

ENV php_conf /etc/php7/php.ini
ENV fpm_conf /etc/php7/php-fpm.d/www.conf

# Add edge cdn
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache bash \
        supervisor \
        nginx \
        curl \
        php7 \
        php7-fpm \
        php7-bcmath \
        php7-bz2 \
        php7-calendar \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-exif \
        php7-ftp \
        php7-gettext \
        php7-gd \
        php7-iconv \
        php7-intl \
        php7-imap \
        php7-json \
        php7-mysqlnd \
        php7-mysqli \
        php7-mcrypt \
        php7-memcached \
        php7-mbstring \
#        php7-opcache \
        php7-openssl \
        php7-pdo \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-phar \
        php7-posix \
        php7-pgsql \
        php7-session \
        php7-soap \
        php7-sockets \
        php7-sqlite3 \
        php7-wddx \
        php7-xml \
        php7-xmlreader \
        php7-xsl \
        php7-zip \
        php7-zlib \
        ca-certificates && \
    rm -rf /var/cache/apk/* && \
    ln -s /usr/bin/php7 /usr/bin/php && \
    mkdir -p /etc/nginx && \
    mkdir -p /run/nginx && \
    mkdir -p /var/log/supervisor && \
    rm -Rf /etc/nginx/nginx.conf && \
    mkdir -p /etc/nginx/sites-available/ && \
    mkdir -p /etc/nginx/sites-enabled/ && \
    mkdir -p /app/public/ && \
    ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

COPY conf/supervisord.conf /etc/supervisord.conf
# Copy our nginx config
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/app-site.conf /etc/nginx/sites-available/default.conf

# tweak php-fpm config
RUN sed -i \
        -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" \
        -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" \
        -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" \
        -e "s/memory_limit\s*=\s*128M/memory_limit = 32M/g" \
        -e "s/;opcache.memory_consumption=64/opcache.memory_consumption=16/g" \
        -e "s/variables_order\s*=\s*\"GPCS\"/variables_order = \"EGPCS\"/g" \
        -e "s/;error_log\s*=\s*php_errors.log/error_log = \/dev\/stderr/g" \
        ${php_conf} && \
    sed -i \
        -e "s/;daemonize\s*=\s*yes/daemonize = no/g" \
        -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
        -e "s/pm.max_children = 4/pm.max_children = 4/g" \
        -e "s/pm.start_servers = 2/pm.start_servers = 3/g" \
        -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" \
        -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" \
        -e "s/pm.max_requests = 500/pm.max_requests = 200/g" \
        -e "s/user = nobody/user = nginx/g" \
        -e "s/group = nobody/group = nginx/g" \
        -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
        -e "s/;listen.owner = nobody/listen.owner = nginx/g" \
        -e "s/;listen.group = nobody/listen.group = nginx/g" \
        -e "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" \
        -e "s/^;clear_env = no$/clear_env = no/" \
        -e "s/^;listen.allowed_clients = 127.0.0.1$/listen.allowed_clients = 127.0.0.1/" \
        ${fpm_conf} && \
    find /etc/php7/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# Add Scripts
COPY scripts/start.sh /start.sh
RUN chmod a+x /start.sh

EXPOSE 80
CMD ["/start.sh"]