.PHONY: help portainer portainer-down run pull gen down clean remove
.SILENT: help get-token del-token

COMPOSE_FILES:=-f docker-compose-nexus-base.yml
OPTIONS:=" arm64 no-secty no-ds mqtt dev ui " # Must have spaces around words for `filter-out` function to work properly

ARGS:=$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

ifeq (dev, $(filter dev,$(ARGS)))
	DEV:="-dev"
endif
ifeq (arm64, $(filter arm64,$(ARGS)))
	ARCH:="-arm64"
	REDIS_ARCH:="arm64v8/"
	KONG_UBUNTU:="-ubuntu"
endif
ifneq (no-ds, $(filter no-ds,$(ARGS)))
	COMPOSE_FILES:=${COMPOSE_FILES} -f docker-compose-nexus-add-device-services.yml
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
USER:=$(wordlist 1,$(words $(SERVICES)),$(SERVICES)) # for use on get-token and del-token

help:
	echo "See README.md in this folder"

portainer:
	docker-compose -p portainer -f docker-compose-portainer.yml up -d

portainer-down:
	docker-compose -p portainer -f docker-compose-portainer.yml down

run:
	DEV=$(DEV) \
	ARCH=$(ARCH) \
	REDIS_ARCH=$(REDIS_ARCH) \
	KONG_UBUNTU=$(KONG_UBUNTU) \
	docker-compose -p edgex $(COMPOSE_FILES) up -d $(SERVICES)

pull:
	ARCH=$(ARCH) \
	REDIS_ARCH=$(REDIS_ARCH) \
	KONG_UBUNTU=$(KONG_UBUNTU) \
	docker-compose -p edgex $(COMPOSE_FILES) pull $(SERVICES)

gen:
	DEV=$(DEV) \
	ARCH=$(ARCH) \
	REDIS_ARCH=$(REDIS_ARCH) \
	KONG_UBUNTU=$(KONG_UBUNTU) \
	docker-compose -p edgex $(COMPOSE_FILES) config > docker-compose.yml

get-token:
	DEV=$(DEV) \
	ARCH=$(ARCH) \
	docker run --rm \
		-e SECRETSERVICE_SERVER=edgex-vault \
		-e KONGURL_SERVER=kong \
		-e SECRETSERVICE_TOKENPATH=/tmp/edgex/secrets/edgex-security-proxy-setup/secrets-token.json \
		-e SECRETSERVICE_CACERTPATH=/tmp/edgex/secrets/ca/ca.pem \
		--network edgex_edgex-network \
		--volume /tmp/edgex/secrets/ca:/tmp/edgex/secrets/ca:ro,z \
		--volume /tmp/edgex/secrets/edgex-security-proxy-setup:/tmp/edgex/secrets/edgex-security-proxy-setup:ro,z \
		nexus3.edgexfoundry.org:10004/docker-edgex-security-proxy-setup-go${ARCH}:master${DEV} \
		--init=false --useradd=${USER} --group=admin \
		| grep " access token for user" | sed 's/.*: \([^.]*\.[^.]*\.[^.]*\).*/\1/'

del-token:
	DEV=$(DEV) \
	ARCH=$(ARCH) \
	docker run --rm \
		-e SECRETSERVICE_SERVER=edgex-vault \
		-e KONGURL_SERVER=kong \
		-e SECRETSERVICE_TOKENPATH=/tmp/edgex/secrets/edgex-security-proxy-setup/secrets-token.json \
		-e SECRETSERVICE_CACERTPATH=/tmp/edgex/secrets/ca/ca.pem \
		--network edgex_edgex-network \
		--volume /tmp/edgex/secrets/ca:/tmp/edgex/secrets/ca:ro,z \
		--volume /tmp/edgex/secrets/edgex-security-proxy-setup:/tmp/edgex/secrets/edgex-security-proxy-setup:ro,z \
		nexus3.edgexfoundry.org:10004/docker-edgex-security-proxy-setup-go${ARCH}:master${DEV} \
		--init=false --userdel=${USER} \
		| grep "successful to delete"

down:
	DEV="" \
	ARCH="" \
	REDIS_ARCH="" \
	KONG_UBUNTU="" \
	docker-compose  -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-device-services.yml \
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