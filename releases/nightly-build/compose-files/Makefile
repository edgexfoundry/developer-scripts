.PHONY: help portainer portainer-down run gen down clean remove
.SILENT: help

COMPOSE_FILES:=-f docker-compose-nexus-base.yml
OPTIONS:=" arm64 no-secty mqtt ui " # Must have spaces around words for `filter-out` function to work properly

ARGS:=$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

ifeq (arm64, $(filter arm64,$(ARGS)))
	ARCH:="-arm64"
	REDIS_ARCH:="arm64v8/"
	KONG_UBUNTU:="-ubuntu"
endif
ifeq (no-secty, $(filter no-secty,$(ARGS)))
	SECURITY:="NO"
else
	SECURITY:="YES"
	COMPOSE_FILES:=${COMPOSE_FILES} -f docker-compose-nexus-add-security.yml
endif
ifeq (mqtt, $(filter mqtt,$(ARGS)))
	ifeq (YES,$(SECURITY))
		COMPOSE_FILES:=${COMPOSE_FILES} -f docker-compose-nexus-add-mqtt.yml -f docker-compose-nexus-add-security.yml
	else
		COMPOSE_FILES:=${COMPOSE_FILES} -f docker-compose-nexus-add-mqtt.yml
	endif
endif
ifeq (ui, $(filter ui,$(ARGS)))
	COMPOSE_FILES:=-f docker-compose-nexus-ui.yml
endif
SERVICES:=$(filter-out $(OPTIONS),$(ARGS))

help:
	echo "Usage: make <target> where target is:"
	echo "   portainer      - Runs Portainer independent of the EdgeX services"
	echo "   portainer-down - Stops Portainer independent of the EdgeX services"
	echo " "
	echo "   run [options] [services] - Runs the EdgeX services as specified by:"
	echo "      Options:"
	echo "         no-secty:   Runs in Non-Secure Mode, otherwise runs in Secure Mode"
	echo "         mqtt:       Runs using MQTT Message Bus and Device MQTT service"
	echo "         ui:         Runs only the option EdgeX UI service. 'mqtt' & 'no-secty' are ignored"
	echo "                     Typically used after the other Edgex Services have been started  "
	echo "         arm64:      Runs using ARM64 images"
	echo "      Services:"
	echo "         <names...>: runs only services listed (and their dependent services) where 'name'"
	echo "                     matches a service name in one of the compose files used"
	echo " "
	echo "   gen [options] - Generates temporary single file compose file (docker-compose.yml) as specified by:"
	echo "      Options:"
	echo "         no-secty:   Generates non-secure compose file, otherwise generates secure compose file"
	echo "         mqtt:       Generates compose file with MQTT Message Bus and Device MQTT service"
	echo "         arm64:      Generates compose file using ARM64 images"
	echo "         ui:         Generates compose file for only EdgeX UI, not useful, but possible"
	echo " "
	echo "   down   - Stops all EdgeX services, including UI, no matter which configuration started them"
	echo "   clean  - Runs 'down' and then removes any stopped containers, prunes unused volumes and networks"
	echo "   remove - Runs 'clean' and then removes all docker images with the 'master' tag"
	echo "            This is how you make sure you are using the very latest 'master' images"
	echo "            It is highly recommended to run this command prior to any validation of your current pull request"

portainer:
	docker-compose -p portainer -f docker-compose-portainer.yml up -d

portainer-down:
	docker-compose -p portainer -f docker-compose-portainer.yml down

run:
	ARCH=$(ARCH) \
	REDIS_ARCH=$(REDIS_ARCH) \
	KONG_UBUNTU=$(KONG_UBUNTU) \
	docker-compose -p edgex $(COMPOSE_FILES) up -d $(SERVICES)

gen:
	ARCH=$(ARCH) \
	REDIS_ARCH=$(REDIS_ARCH) \
	KONG_UBUNTU=$(KONG_UBUNTU) \
	docker-compose -p edgex $(COMPOSE_FILES) config > docker-compose.yml

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