#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
${symbol_pound}! /bin/sh
echo "Configuring Vault..."

${symbol_pound} Wait up to 60 seconds for Vault to be available
until ${symbol_dollar}(curl -XGET --insecure --fail --output /dev/null --silent -H "X-Vault-Token: ${symbol_dollar}VAULT_TOKEN" ${symbol_dollar}VAULT_ADDR/v1/sys/health); do
    echo "Waiting for Vault to be available..."
    sleep 10
done

${symbol_pound} Authenticate to Vault
vault login ${symbol_dollar}VAULT_DEV_ROOT_TOKEN_ID

${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound} Enable Consul Secret Backend ${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}
vault secrets enable consul

${symbol_pound} Retrieve ACL token from Consul
ACL_TOKEN=${symbol_dollar}(curl -ks ${symbol_escape}
    --header "X-Consul-Token: ${symbol_dollar}{CONSUL_HTTP_TOKEN}" ${symbol_escape}
    --request PUT ${symbol_escape}
    --data '{"Name": "sample", "Policies": [{"name": "global-management"}]}' ${symbol_escape}
    ${symbol_dollar}{CONSUL_HTTP_ADDR}/v1/acl/token | jq -r .SecretID)

vault write consul/config/access ${symbol_escape}
    address=${symbol_dollar}{CONSUL_HTTP_ADDR} ${symbol_escape}
    token=${symbol_dollar}{ACL_TOKEN}

${symbol_pound} Create Token Policy
consul acl policy create  -name "readonly" -description "Read Only Policy" -rules @/token-policy.hcl

${symbol_pound} Configure Role Mapping
vault write consul/roles/os-svc policies=readonly

${symbol_pound} Create Sample Properties in Consul
consul kv put config/bip-${artifactNameLowerCase}/spring.redis.port 6379

${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}${symbol_pound}
