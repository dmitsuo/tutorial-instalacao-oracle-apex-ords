#!/bin/bash

set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh && \
sed -i "s# *<\\/properties> *#<entry key=\"misc.defaultPage\">apex</entry>\n</properties>#" "${ORDS_CONFIG}/global/settings.xml" && \
cat "${ORDS_CONFIG}/global/settings.xml"