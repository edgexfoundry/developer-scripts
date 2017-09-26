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


installAllModules(){
SELECTED_MODULES=($@)
for m in ${SELECTED_MODULES[@]} ;  do
    if [ -d $m ] ; then
        echo "Updating $m"
        cd $m
        git pull
        echo $m
        cd ..
    else
        echo "Cloning $m"
        git clone https://github.com/edgexfoundry/$m
    fi
done

}

usage(){
	echo "Error, you must press 'y' or 'n'"
	exit 0
}


start(){

echo -n "Do you want to install all modules or select from the list? (y/n) -> "

read ans

if [[ "$ans" == "y" ]]; then
	installAllModules "${MODULES[@]}"
elif [[ "$ans" == "n" ]]; then
	for m in ${MODULES[@]} ; do
		echo -n "Do you want to install $m? (y/n) -> "
		read insmodule 
		if [[ "$insmodule" == "y" ]]; then
			MOD+=($m)
		fi
	done

	echo "${MOD[@]} modules selected"
	installAllModules "${MOD[@]}" 
else
	usage

fi



echo "Done!"
}



if [ $# -eq 0 ]; then
	. ./MODULES
	start
else
	installAllModules $@
fi

