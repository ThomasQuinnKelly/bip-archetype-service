# Starts the openshift origin spring boot service, including consul, vault and redis

docker-compose -f docker-compose.yml \
	up --build -d
