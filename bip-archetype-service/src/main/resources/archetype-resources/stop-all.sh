#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
${symbol_pound} Stops the entire platform, including all log aggregation services

docker-compose -f docker-compose.yml ${symbol_escape}
	down -v
