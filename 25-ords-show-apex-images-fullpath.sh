#!/bin/bash

set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

## Copiar a saida do comando abaixo, que sera necessario durante a instalacao do ORDS
. ./00-set-apex-ords-env.sh && echo "Apex Images full path: ${APEX_IMAGES}"