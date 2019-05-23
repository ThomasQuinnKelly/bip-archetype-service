#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
${symbol_pound}!/bin/sh
set -e

${symbol_pound} Wrapper script for the offical consul docker container. Configures ACLs based on provided environment variables.
${symbol_pound} THIS IS FOR LOCAL DEVELOPMENT ONLY AS SUPPLYING ACL TOKEN VIA ENVIRONMENT VARIABLES IS NOT SECURE

if [ -n "${symbol_dollar}MASTER_ACL_TOKEN" ]; then
    if [ -z "${symbol_dollar}AGENT_ACL_TOKEN" ]; then
        AGENT_ACL_TOKEN="${symbol_dollar}MASTER_ACL_TOKEN"
    fi

    cat > /consul/config/acl.json <<EOF
{
    "acl": {
        "enabled": true,
        "default_policy": "deny",
        "down_policy": "extend-cache",
        "tokens": {
            "master": "${symbol_dollar}MASTER_ACL_TOKEN",
            "agent": "${symbol_dollar}AGENT_ACL_TOKEN"
        }
    }
}
EOF
fi

${symbol_pound} Proceed with Consul entrypoint script
docker-entrypoint.sh "${symbol_dollar}@"