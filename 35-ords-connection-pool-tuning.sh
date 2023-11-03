#!/bin/bash

set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh && \
sed -i "s# *<\\/properties> *#<entry key=\"jdbc.InitialLimit\">5</entry>\n</properties>#" "${ORDS_CONFIG}/databases/default/pool.xml" && \
sed -i "s# *<\\/properties> *#<entry key=\"jdbc.MaxLimit\">25</entry>\n</properties>#" "${ORDS_CONFIG}/databases/default/pool.xml" && \
cat "${ORDS_CONFIG}/databases/default/pool.xml"