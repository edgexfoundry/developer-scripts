#!/bin/sh

# Copyright 2017 Konrad Zapalowicz <bergo.torino@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Start EdgeX Foundry services in right order, as described:
# https://wiki.edgexfoundry.org/display/FA/Get+EdgeX+Foundry+-+Users

COMPOSE_FILE=${1:-docker-compose.yml}

run_service () {
    
    echo -e "\033[0;32mStarting.. $1\033[0m"
    docker-compose -f "$COMPOSE_FILE" up -d $1
	
    if [ "$1" = "config-seed" ]
    then
         while [ -z "$(curl -s http://localhost:8500/v1/kv/config/support-scheduler\;docker/app.open.msg)" ]
         do
               sleep 1
         done
         echo "$1 has been completely started !"
         return
    fi

    if [ -z "$2" ]
    then
         sleep 10
         echo "$1 has been completely started !"
         return
    fi
    
    while [ -z "$(docker-compose -f $COMPOSE_FILE exec $1 netstat -ntl | grep $2)" ]
    do
        sleep 1
    done

    echo "$1 has been completely started !"
}

run_service volume

run_service config-seed

run_service mongo

run_service logging 48061

run_service notifications 48060

run_service metadata 48081

run_service data 48080

run_service command 48082

run_service scheduler 48085

run_service export-client 48071

run_service export-distro 48070

run_service rulesengine 48075

run_service device-virtual 49990
