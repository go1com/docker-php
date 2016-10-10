#!/bin/bash

# Set custom webroot
if [ ! -z "$WEBROOT" ]; then
  webroot=$WEBROOT
  sed -i "s#root /app/public;#root ${webroot};#g" /etc/nginx/sites-available/default.conf
else
  webroot=/app/public
fi

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

# Always chown webroot for better mounting
chown -Rf nginx.nginx $webroot

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf