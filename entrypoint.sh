#!/usr/bin/env bash

vars=`set | grep _DOCKER_`
vars=$(echo $vars | tr "\n")

for var in $vars
do
    key=$(echo "$var" | sed -E 's/_DOCKER_([^=]+).+/\1/g')
    var=$(echo "$var" | sed -E 's/_DOCKER_([^=]+).+/_DOCKER_\1/g')
    eval val=\$$var
    sed -i "2s/^/SetEnv $key $val\n/" app.conf
done

apache2-foreground