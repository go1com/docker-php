#!/bin/bash

# Set custom webroot
if [ ! -z "$WEBROOT" ]; then
  webroot=$WEBROOT
  sed -i "s#root /app/public;#root ${webroot};#g" /etc/nginx/sites-available/default.conf
else
  webroot=/app/public
fi

# Set custom location root
if [ ! -z "$LOCATIONROOT" ]; then
  location=$LOCATIONROOT
  sed -i "s#location / {#location ${location} {#g" /etc/nginx/sites-available/default.conf
  sed -i "s#/index.php#${location}/index.php#g" /etc/nginx/sites-available/default.conf
fi

# Always chown webroot for better mounting
chown -Rf www-data.www-data $webroot

# Convert env
vars=`set | grep _DOCKER_`
vars=$(echo $vars | tr "\n")

for var in $vars
do
    key=$(echo "$var" | sed -E 's/_DOCKER_([^=]+).+/\1/g')
    var=$(echo "$var" | sed -E 's/_DOCKER_([^=]+).+/_DOCKER_\1/g')
    eval val=\$$var
    export ${key}=${val}
done

# Allow run custom script
if [ ! -z "$SCRIPT" ] && [ -f "$SCRIPT" ]; then
  chmod a+x $SCRIPT
  . $SCRIPT
fi

if [ -f /app/resources/docker/hook-start ]; then
    source /app/resources/docker/hook-start
fi

php-fpm

nginx
