#!/bin/bash

# Copyright 2017 Cavium Inc.
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
# Author: chencho

set -e

DOCKERS=( docker-edgex-volume docker-core-consul core-config-seed docker-edgex-mongo support-logging \
    support-notifications core-metadata core-data core-command support-scheduler export-client \
    export-distro support-rulesengine device-virtual device-bacnet device-bluetooth device-modbus device-mqtt device-snmp)

DOCKERFILE=$1

usage(){
    echo -e "ERROR! Dockerfile name not found."
    echo -e "\tI.E: ./${0} Dockerfile.aarch64"
    exit
}


if [[ -z ${DOCKERFILE} ]]; then
    usage
fi

for m in ${DOCKERS[@]} ;  do
    if [ -d $m ]; then
        echo "Updating git modules... "
        cd $m
        git pull
        cd ..
    else
        echo "Cloning $m"
        git clone https://github.com/edgexfoundry/$m
    fi
    if [ -f $m/docker-files/${DOCKERFILE} ] ; then
        echo "Creating docker image $m"
        cd $m
        docker build . -t edgexfoundry/docker-$m -f docker-files/${DOCKERFILE}
        echo $m
        cd ..

    elif [ -f $m/${DOCKERFILE} ] ; then
        echo "Creating docker image $m"
        cd $m
        docker build . -t edgexfoundry/$m -f ${DOCKERFILE}
        echo $m
        cd ..
    else
        usage
    fi
done


echo "Done!"
