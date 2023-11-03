#!/bin/bash

set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh

ORDS_CONTAINER_NAME="ords23-tomcat"
ORDS_CONTAINER_HTTP_PORT=8080
ORDS_CONTAINER_HTTPS_PORT=8443

### FAVOR NAO ALTERAR NADA A PARTIR DESTE PONTO PARA BAIXO
### PLEASE DO NOT ALTER ANYTHING FROM THIS POINT DOWNWARDS

set -eu
ORDS_CONTAINER_USER_UID=1000
ORDS_CONTAINER_CONFIG_DIR="/opt/ords-config"
ORDS_CONTAINER_APEX_IMAGES_DIR="/usr/local/tomcat/webapps/i"
DEFAULT_TIMEZONE="America/Fortaleza"

sudo docker rm -f $ORDS_CONTAINER_NAME
sudo docker rmi -f $ORDS_CONTAINER_NAME

sudo chown -Rf $ORDS_CONTAINER_USER_UID:$ORDS_CONTAINER_USER_UID $APEX_ORDS_DIR

sudo docker build --build-arg ARG_ORDS_CONTAINER_USER_UID="$ORDS_CONTAINER_USER_UID" \
                  --build-arg ARG_ORDS_CONTAINER_CONFIG_DIR="$ORDS_CONTAINER_CONFIG_DIR" \
                  --build-arg ARG_DEFAULT_TIMEZONE="$DEFAULT_TIMEZONE" \
                  --build-arg ARG_ORDS_WAR_PATH="./${ORDS_BASE_NAME}/ords.war" \
                   -t "$ORDS_CONTAINER_NAME" .

sudo docker run --name "$ORDS_CONTAINER_NAME" -h "$ORDS_CONTAINER_NAME" -d     \
                -v $ORDS_CONFIG:$ORDS_CONTAINER_CONFIG_DIR \
                -v $APEX_IMAGES:$ORDS_CONTAINER_APEX_IMAGES_DIR \
                -p $ORDS_CONTAINER_HTTP_PORT:8080 \
                -p $ORDS_CONTAINER_HTTPS_PORT:8443 \
                -u $ORDS_CONTAINER_USER_UID:$ORDS_CONTAINER_USER_UID \
                "$ORDS_CONTAINER_NAME"

sudo docker logs -f -n 100 "$ORDS_CONTAINER_NAME"