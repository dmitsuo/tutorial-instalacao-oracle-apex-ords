#!/bin/bash

set -eux

export APEX_ORDS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd "$APEX_ORDS_DIR"

. ./00-set-apex-ords-env.sh && \
cd "${APEX_BASE_DIR}/apex" && \
sql -S /nolog << EOF

    connect sys/${DB_SERVER_PWD}@//${DB_SERVER_IP}:${DB_SERVER_PORT}/${DB_SERVER_SERVICE_NAME} as sysdba

    set define off    

    prompt Executing Apex main installation script: apexins.sql
    @apexins.sql "${APEX_TABLESPACE}" "${APEX_TABLESPACE}" "TEMP" "/i/"

    prompt Executing Apex REST configuration script: apex_rest_config_core.sql
    @apex_rest_config_core.sql @ "${DB_SERVER_APEX_USERS_PWD}" "${DB_SERVER_APEX_USERS_PWD}"    

    prompt Reset passwords and unlock APEX database users
    alter user APEX_230100           identified by "${DB_SERVER_APEX_USERS_PWD}" account unlock;
    alter user FLOWS_FILES           identified by "${DB_SERVER_APEX_USERS_PWD}" account unlock;
    alter user APEX_PUBLIC_USER      identified by "${DB_SERVER_APEX_USERS_PWD}" account unlock;
    alter user APEX_REST_PUBLIC_USER identified by "${DB_SERVER_APEX_USERS_PWD}" account unlock;
    alter user APEX_LISTENER         identified by "${DB_SERVER_APEX_USERS_PWD}" account unlock;    

    prompt Setup Network ACL for APEX database user
    begin
        for c1 in (
            select schema
            from sys.dba_registry
            where comp_id = 'APEX'
        ) loop
            sys.dbms_network_acl_admin.append_host_ace(
                host => '*', 
                ace  => xs\$ace_type(
                    privilege_list => xs\$name_list('connect'), 
                    principal_name => c1.schema, 
                    principal_type => xs_acl.ptype_db
                )
        );
    end loop;
    commit;
    end;
    /

    prompt Setup APEX ADMIN account for its development environment (INTERNAL Workspace)
    begin
    apex_util.set_workspace(p_workspace => 'internal');
    apex_util.create_user(
        p_user_name => 'ADMIN'
        , p_email_address => 'ADMIN'
        , p_web_password => '${APEX_ADMIN_PWD}'
        , p_developer_privs => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL'
        , p_change_password_on_first_use => 'N'
    );
    commit;
    end;
    /

    prompt Setup PT-BR language for APEX
    @builder/pt-br/load_pt-br.sql
    
    set define on

    quit

EOF
