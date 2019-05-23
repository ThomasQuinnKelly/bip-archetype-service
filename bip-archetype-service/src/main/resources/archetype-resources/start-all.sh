#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
${symbol_pound} Starts the openshift ${artifactNameLowerCase} spring boot service, including consul, vault and redis

docker-compose -f docker-compose.yml ${symbol_escape}
	up --build -d
