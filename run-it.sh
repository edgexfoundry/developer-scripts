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

run_service () {
	echo -e "\033[0;32mStarting.. $1\033[0m"
	docker-compose up -d $1
}

run_service volume
sleep 10
run_service config-seed
run_service mongo
sleep 12
run_service logging
sleep 65
run_service notifications
sleep 33
run_service metadata
sleep 60
run_service data
sleep 60
run_service command
sleep 60
run_service scheduler
sleep 60
run_service export-client
sleep 60
run_service export-distro
sleep 60
run_service rulesengine
sleep 60
run_service device-virtual
