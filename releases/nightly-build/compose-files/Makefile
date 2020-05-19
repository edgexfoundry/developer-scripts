.PHONY: portainer portainer-down run run-no-sec run-mqtt run-mqtt-no-sec run-arm run-arm-no-sec run-mqtt-arm run-mqtt-arm-no-sec down clean remove

portainer:
	docker-compose -p portainer -f docker-compose-portainer.yml up -d

portainer-down:
	docker-compose -p portainer -f docker-compose-portainer.yml down

run:
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-security.yml \
		up -d

run-no-sec:
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		up -d

run-mqtt:
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-mqtt.yml \
		-f docker-compose-nexus-add-security.yml \
		up -d

run-mqtt-no-sec:
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		up -d

run-arm:
	ARCH="-arm64" \
	REDIS_ARCH="arm64v8/" \
	KONG_UBUNTU="-ubuntu" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-security.yml \
		up -d

run-arm-no-sec:
	ARCH="-arm64" \
	REDIS_ARCH="arm64v8/" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		up -d

run-mqtt-arm:
	ARCH="-arm64" \
	REDIS_ARCH="arm64v8/" \
	KONG_UBUNTU="-ubuntu" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-mqtt.yml \
		-f docker-compose-nexus-add-security.yml \
		up -d

run-mqtt-arm-no-sec:
	ARCH="-arm64" \
	REDIS_ARCH="arm64v8/" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		up -d

run-ui:
	docker-compose -p edgex \
		-f docker-compose-nexus-ui.yml \
		up -d

run-ui-arm:
	ARCH="-arm64" \
	docker-compose -p edgex \
		-f docker-compose-nexus-ui.yml \
		up -d

down:
	docker-compose  -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-mqtt.yml \
		-f docker-compose-nexus-add-security.yml \
		-f docker-compose-nexus-ui.yml \
		down

clean: down
	-docker rm $$(docker ps -aq)
	docker volume prune -f && \
	docker network prune -f

#TODO: When cutting next release, remove this make target as it only needed when release = "master".
remove: clean
	docker rmi -f $$(docker images | grep master | awk '{print $$3}')