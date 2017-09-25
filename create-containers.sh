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

DOCKERS=( docker-edgex-volume docker-core-consul  docker-core-config-seed  docker-edgex-mongo support-logging \
    support-notifications     core-metadata      core-data     core-command     support-scheduler     export-client \
    export-distro     support-rulesengine      device-virtual  )


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
    if [ -f $m/docker-files/Dockerfile.aarch64 ] ; then
        echo "Creating docker image $m"
        cd $m
        docker build . -t edgexfoundry/docker-$m -f docker-files/Dockerfile.aarch64
        echo $m
        cd ..
    
    elif [ -f $m/Dockerfile.aarch64 ] ; then
        echo "Creating docker image $m"
        cd $m
        docker build . -t edgexfoundry/$m -f Dockerfile.aarch64
        echo $m
        cd ..
    fi
done


echo "Done!"

