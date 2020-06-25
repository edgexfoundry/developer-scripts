# /*******************************************************************************
#  * Copyright 2020 Intel
#  *
#  * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
#  * in compliance with the License. You may obtain a copy of the License at
#  *
#  * http://www.apache.org/licenses/LICENSE-2.0
#  *
#  * Unless required by applicable law or agreed to in writing, software distributed under the License
#  * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
#  * or implied. See the License for the specific language governing permissions and limitations under
#  * the License.
#  *
#  *******************************************************************************/

.PHONY: help portainer portainer-down run pull gen down clean remove
.SILENT: help get-token del-token

include .env

COMPOSE_FILES:=-f docker-compose-nexus-base.yml
OPTIONS:=" arm64 no-secty no-ds mqtt dev ui " # Must have spaces around words for `filter-out` function to work properly

ARGS:=$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

ifeq (dev, $(filter dev,$(ARGS)))
	CORE_EDGEX_REPOSITORY=edgexfoundry
	DEV:=-dev
endif
ifeq (arm64, $(filter arm64,$(ARGS)))
	ARCH:=-arm64
	KONG_UBUNTU:=-ubuntu
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

run: gen
	docker-compose -p edgex up -d $(SERVICES)

pull: gen
	docker-compose pull $(SERVICES)

gen:
	DEV=$(DEV) \
	CORE_EDGEX_REPOSITORY=$(CORE_EDGEX_REPOSITORY) \
	ARCH=$(ARCH) \
	KONG_UBUNTU=$(KONG_UBUNTU) \
	docker-compose -p edgex $(COMPOSE_FILES) config > docker-compose.yml

get-token:
	docker run --rm \
		-e SECRETSERVICE_SERVER=edgex-vault \
		-e KONGURL_SERVER=kong \
		-e SECRETSERVICE_TOKENPATH=/tmp/edgex/secrets/edgex-security-proxy-setup/secrets-token.json \
		-e SECRETSERVICE_CACERTPATH=/tmp/edgex/secrets/ca/ca.pem \
		--network edgex_edgex-network \
		--volume /tmp/edgex/secrets/ca:/tmp/edgex/secrets/ca:ro,z \
		--volume /tmp/edgex/secrets/edgex-security-proxy-setup:/tmp/edgex/secrets/edgex-security-proxy-setup:ro,z \
		$(CORE_EDGEX_REPOSITORY)/docker-edgex-security-proxy-setup-go$(ARCH):$(CORE_EDGEX_VERSION)$(DEV) \
		--init=false --useradd=${USER} --group=admin \
		| grep " access token for user" | sed 's/.*: \([^.]*\.[^.]*\.[^.]*\).*/\1/'

del-token:
	source .env
	docker run --rm \
		-e SECRETSERVICE_SERVER=edgex-vault \
		-e KONGURL_SERVER=kong \
		-e SECRETSERVICE_TOKENPATH=/tmp/edgex/secrets/edgex-security-proxy-setup/secrets-token.json \
		-e SECRETSERVICE_CACERTPATH=/tmp/edgex/secrets/ca/ca.pem \
		--network edgex_edgex-network \
		--volume /tmp/edgex/secrets/ca:/tmp/edgex/secrets/ca:ro,z \
		--volume /tmp/edgex/secrets/edgex-security-proxy-setup:/tmp/edgex/secrets/edgex-security-proxy-setup:ro,z \
		$(CORE_EDGEX_REPOSITORY)/docker-edgex-security-proxy-setup-go$(ARCH):$(CORE_EDGEX_VERSION)$(DEV) \
		--init=false --userdel=${USER} \
		| grep "successful to delete"

down:
	docker-compose -p edgex down

clean: down
	-docker rm $$(docker ps --filter "network=edgex_edgex-network" --filter "network=edgex_default" -aq) 2> /dev/null
	docker volume prune -f && \
	docker network prune -f