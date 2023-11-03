#!/bin/bash

set -eux

# Geral
export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
find . -type f -name "*.sh" -exec chmod +x {} \;

# JAVA
export JAVA_HOME="$APEX_ORDS_DIR/java-11"
export JAVA_INSTALL_PACKAGE="OpenJDK11U-jdk_x64_linux_hotspot_11.0.21_9.tar.gz"
mkdir -p ${JAVA_HOME}

# ORDS
export ORDS_VERSION="23.3.0.289.1830"
export ORDS_BASE_NAME="ords-${ORDS_VERSION}"
export ORDS_HOME="$APEX_ORDS_DIR/$ORDS_BASE_NAME"
export ORDS_CONFIG="${APEX_ORDS_DIR}/ords-config"
export ORDS_LOGS="${APEX_ORDS_DIR}/ords-logs"
export ORDS_INSTALL_PACKAGE="${ORDS_BASE_NAME}.zip"
mkdir -p "${ORDS_HOME}"
mkdir -p "${ORDS_CONFIG}"
mkdir -p "${ORDS_LOGS}"

# APEX
export APEX_VERSION="23.1"
export APEX_IMAGES="${APEX_ORDS_DIR}/apex-images"
export APEX_BASE_NAME="apex_${APEX_VERSION}"
export APEX_BASE_DIR="$APEX_ORDS_DIR/$APEX_BASE_NAME"
export APEX_INSTALL_PACKAGE="${APEX_BASE_NAME}.zip"
APEX_ADMIN_PWD="OracleApex_23"
# A tablespace abaixo pode ser substituída por outra que tenha sido criada especificamente para o APEX e ORDS
export APEX_TABLESPACE="SYSAUX"
mkdir -p ${APEX_BASE_DIR}

# SQLcl
export SQLCL_HOME="$APEX_ORDS_DIR/sqlcl"
export SQLCL_INSTALL_PACKAGE="sqlcl-latest.zip"

# Database
export DB_SERVER_IP="localhost"
export DB_SERVER_PORT="1521"
export DB_SERVER_SERVICE_NAME="xepdb1"
DB_SERVER_PWD="oracle"
DB_SERVER_APEX_USERS_PWD="oracle"

if ! [[ $PATH =~ (^|:)${SQLCL_HOME}/bin(:|$) ]]; then
  export PATH="${JAVA_HOME}/bin:${SQLCL_HOME}/bin:${ORDS_HOME}/bin:$PATH"
fi