#!/bin/bash

set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh && \
curl -L -k -o "${ORDS_INSTALL_PACKAGE}" "https://download.oracle.com/otn_software/java/ords/${ORDS_INSTALL_PACKAGE}" && \
unzip -q "${ORDS_INSTALL_PACKAGE}" -d "${ORDS_HOME}"