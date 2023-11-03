#!/bin/bash

set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh && \
curl -L -k -o "$JAVA_INSTALL_PACKAGE" "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.21%2B9/${JAVA_INSTALL_PACKAGE}" && \
tar -xzf "$JAVA_INSTALL_PACKAGE" --strip-components 1 -C "$JAVA_HOME" && \
curl -L -k -o "$SQLCL_INSTALL_PACKAGE" "https://download.oracle.com/otn_software/java/sqldeveloper/${SQLCL_INSTALL_PACKAGE}" && \
unzip -q "$SQLCL_INSTALL_PACKAGE"