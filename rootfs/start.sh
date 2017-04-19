#!/bin/bash

# Set custom webroot
if [ ! -z "$WEBROOT" ]; then
  webroot=$WEBROOT
else
  webroot=/app/public
fi
sed -i "s#^DocumentRoot \".*#DocumentRoot \"/$webroot\"#g" /etc/apache2/httpd.conf
sed -i "s#/var/www/localhost/htdocs#/$webroot#" /etc/apache2/httpd.conf
printf "\n<Directory \"/$webroot\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf

# Always chown webroot for better mounting
mkdir -p $webroot
chown -Rf apache.www-data $webroot

# Allow run custom script
if [ ! -z "$SCRIPT" ] && [ -f "$SCRIPT" ]; then
  chmod a+x $SCRIPT
  . $SCRIPT
fi

if [ -f /app/resources/docker/hook-start ]; then
    source /app/resources/docker/hook-start
fi

httpd -D FOREGROUND