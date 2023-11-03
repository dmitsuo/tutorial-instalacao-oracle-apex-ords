#!/bin/bash

set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh && \
curl -L -k -o "${APEX_INSTALL_PACKAGE}" "https://download.oracle.com/otn_software/apex/${APEX_INSTALL_PACKAGE}" && \
unzip -q "${APEX_INSTALL_PACKAGE}" -d "${APEX_BASE_DIR}" && \
mv "${APEX_BASE_DIR}/apex/images" "${APEX_IMAGES}"