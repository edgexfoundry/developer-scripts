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

.PHONY: help portainer portainer-down build build-ui run pull gen get-token ui-down down clean
.SILENT: help get-token del-token

include .env

COMPOSE_FILES:=-f docker-compose-nexus-base.yml
OPTIONS:=" arm64 no-secty no-ds mqtt dev ui " # Must have spaces around words for `filter-out` function to work properly

ARGS:=$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

# Order of processing these arguments is important so the overrides in the 'add` compose files occur properly.
ifeq (dev, $(filter dev,$(ARGS)))
	CORE_EDGEX_REPOSITORY=edgexfoundry
	DEV:=-dev
	# matches the way that edgex-go to versioning the docker images for `make docker`
	CORE_EDGEX_VERSION:="0.0.0"
endif
ifeq (arm64, $(filter arm64,$(ARGS)))
	ARCH:=-arm64
	KONG_UBUNTU:=-ubuntu
endif
ifneq (no-ds, $(filter no-ds,$(ARGS)))
	COMPOSE_FILES:=$(COMPOSE_FILES) -f docker-compose-nexus-add-device-services.yml
else
	NO_DS:=-no-ds
endif
ifeq (mqtt, $(filter mqtt,$(ARGS)))
	COMPOSE_FILES:=$(COMPOSE_FILES) -f docker-compose-nexus-add-mqtt.yml
	MQTT:=-mqtt
endif
ifeq (no-secty, $(filter no-secty,$(ARGS)))
	NO_SECURITY:=-no-secty
else
	COMPOSE_FILES:=$(COMPOSE_FILES) -f docker-compose-nexus-add-security.yml
endif
ifeq (ui, $(filter ui,$(ARGS)))
	COMPOSE_FILES:=-f docker-compose-nexus-ui.yml
	UI:=-ui
endif
SERVICES:=$(filter-out $(OPTIONS),$(ARGS))

help:
	echo "See README.md in this folder"

portainer:
	cd ..; \
	make portainer

portainer-down:
	cd ..; \
	make portainer-down

build:
	make compose
	make compose arm64
	make compose no-secty
	make compose no-secty arm64
	make compose ui
	make compose ui arm64

compose: gen
	cat gen-header docker-compose.yml > ../docker-compose-$(RELEASE)$(NO_DS)$(UI)$(NO_SECURITY)$(MQTT)$(ARCH)$(DEV).yml

run: gen
	docker-compose -p edgex up -d $(SERVICES)

pull: gen
	docker-compose pull $(SERVICES)

gen:
	DEV=$(DEV) \
	CORE_EDGEX_REPOSITORY=$(CORE_EDGEX_REPOSITORY) \
	CORE_EDGEX_VERSION=$(CORE_EDGEX_VERSION) \
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
		--init=false --useradd=developer --group=admin \
		| grep " access token for user developer" | sed 's/.*: \([^.]*\.[^.]*\.[^.]*\).*/\1/'

ui-down:
	DEV= \
	CORE_EDGEX_REPOSITORY=$(CORE_EDGEX_REPOSITORY) \
	ARCH= \
	KONG_UBUNTU= \
	docker-compose -p edgex -f docker-compose-nexus-ui.yml down

down: ui-down
	DEV= \
	CORE_EDGEX_REPOSITORY=$(CORE_EDGEX_REPOSITORY) \
	ARCH= \
	KONG_UBUNTU= \
	docker-compose -p edgex \
		-f docker-compose-nexus-base.yml \
		-f docker-compose-nexus-add-device-services.yml \
		-f docker-compose-nexus-add-mqtt.yml \
		-f docker-compose-nexus-add-security.yml \
		down

clean: down
	-docker rm $$(docker ps --filter "network=edgex_edgex-network" --filter "network=edgex_default" -aq) 2> /dev/null
	docker volume prune -f && \
	docker network prune -f