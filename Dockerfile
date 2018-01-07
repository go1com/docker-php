FROM go1com/php:7-nginx

COPY rootfs/etc/nginx/sites-available/default.conf /etc/nginx/sites-available/default.conf
