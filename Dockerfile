FROM tomcat:9.0.73-jdk11-temurin-jammy

ARG ARG_ORDS_CONTAINER_USER_UID="1000"
ARG ARG_ORDS_CONTAINER_CONFIG_DIR="/opt/ords-config"
ARG ARG_DEFAULT_TIMEZONE="America/Fortaleza"
ARG ARG_ORDS_WAR_PATH

ENV TZ="$ARG_DEFAULT_TIMEZONE"

RUN set -eux ; \
    echo "\nexport JAVA_OPTS=\"\$JAVA_OPTS -Dconfig.url=$ARG_ORDS_CONTAINER_CONFIG_DIR -Duser.language=pt -Duser.country=BR -Duser.timezone=${ARG_DEFAULT_TIMEZONE}\"" >> ${CATALINA_HOME}/bin/setenv.sh ; \
    chown -R $ARG_ORDS_CONTAINER_USER_UID:$ARG_ORDS_CONTAINER_USER_UID ${CATALINA_HOME} ; \
    chmod -R 750 ${CATALINA_HOME}

COPY --chown=$ARG_ORDS_CONTAINER_USER_UID:$ARG_ORDS_CONTAINER_USER_UID "$ARG_ORDS_WAR_PATH" $CATALINA_HOME/webapps/

EXPOSE 8080 8443