.PHONY: help portainer portainer-down run run-no-sec run-mqtt run-mqtt-no-sec run-ui run-arm run-mqtt-arm run-mqtt-no-sec-arm run-ui-arm down clean remove
.SILENT: help

help:
	echo "Usage: make <target> where target is:"
	echo "   portainer           - Runs Portainer independent of the EdgeX services"
	echo "   portainer-down      - Stops Portainer independent of the EdgeX services"
	echo "   run                 - Runs the EdgeX services in secure mode"
	echo "   run-no-sec          - Runs the EdgeX services in non-secure mode"
	echo "   run-mqtt            - Runs the EdgeX services using MQTT Message Buss in secure mode, including the Device MQTT service"
	echo "   run-mqtt-no-sec     - Runs the EdgeX services using MQTT Message Buss in non-secure mode, including the Device MQTT service"
	echo "   run-ui              - Runs the optional EdgeX UI service"
	echo "   run-arm             - Same as 'run', but using ARM64 images"
	echo "   run-no-sec-arm      - Same as 'run-no-sec', but using ARM64 images"
	echo "   run-mqtt-arm        - Same as 'run-mqtt', but using ARM64 images"
	echo "   run-mqtt-no-sec-arm - Same as 'run-mqtt-no-sec', but using ARM64 images"
	echo "   run-ui-arm          - Same as 'run-ui', but using ARM64 image"
	echo "   down                - Stops all EdgeX service no matter which configuration started them"
	echo "   clean               - Runs 'down' and then removes any stopped containers, prunes unused volumes and networks"
	echo "   remove              - Runs 'clean' and then removes all docker images with the 'master' tag"
	echo "                         This is how you make sure you are using the very latest 'master' images"
	echo "                         It is highly recommended to run this command prior to any validation of your current pull request"
	echo ""
	echo "*** Note that all 'run' commands take optional list of service(s) to run"

portainer:
	docker-compose -p portainer -f docker-compose-portainer.yml up -d

portainer-down:
	docker-compose -p portainer -f docker-compose-portainer.yml down


SERVICES_TO_RUN := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(SERVICES_TO_RUN):;@:)

run:
	ARCH="" \
	REDIS_ARCH="" \
	KONG_UBUNTU="" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-security.yml \
		up -d $(SERVICES_TO_RUN)

run-no-sec:
	ARCH="" \
	REDIS_ARCH="" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		up -d $(SERVICES_TO_RUN)

run-mqtt:
	ARCH="" \
	REDIS_ARCH="" \
	KONG_UBUNTU="" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-mqtt.yml \
		-f docker-compose-nexus-add-security.yml \
		up -d $(SERVICES_TO_RUN)

run-mqtt-no-sec:
	ARCH="" \
	REDIS_ARCH="" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-mqtt.yml \
		up -d $(SERVICES_TO_RUN)

run-arm:
	ARCH="-arm64" \
	REDIS_ARCH="arm64v8/" \
	KONG_UBUNTU="-ubuntu" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-security.yml \
		up -d $(SERVICES_TO_RUN)

run-arm-no-sec:
	ARCH="-arm64" \
	REDIS_ARCH="arm64v8/" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		up -d $(SERVICES_TO_RUN)

run-mqtt-arm:
	ARCH="-arm64" \
	REDIS_ARCH="arm64v8/" \
	KONG_UBUNTU="-ubuntu" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-mqtt.yml \
		-f docker-compose-nexus-add-security.yml \
		up -d $(SERVICES_TO_RUN)

run-mqtt-no-sec-arm:
	ARCH="-arm64" \
	REDIS_ARCH="arm64v8/" \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-mqtt.yml \
		up -d $(SERVICES_TO_RUN)

run-ui:
	ARCH="" \
	docker-compose -p edgex \
		-f docker-compose-nexus-ui.yml \
		up -d $(SERVICES_TO_RUN)

run-ui-arm:
	ARCH="-arm64" \
	docker-compose -p edgex \
		-f docker-compose-nexus-ui.yml \
		up -d $(SERVICES_TO_RUN)

down:
	ARCH="" \
	REDIS_ARCH="" \
	KONG_UBUNTU="" \
	docker-compose  -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-mqtt.yml \
		-f docker-compose-nexus-add-security.yml \
		-f docker-compose-nexus-ui.yml \
		down

clean: down
	-docker rm $$(docker ps --filter "network=edgex_edgex-network" --filter "network=edgex_default" -aq) 2> /dev/null
	docker volume prune -f && \
	docker network prune -f

#TODO: When cutting next release, remove this make target as it only needed when release = "master".
remove: clean
	-docker rmi -f $$(docker images | grep master | awk '{print $$3}') 2> /dev/null