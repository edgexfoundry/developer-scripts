#!/bin/bash

#################################################################################
# Copyright 2017 Dell Inc.
# Chad Young <chad.young@dell.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
# in compliance with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under
# the License.
#
#################################################################################

# The user must define this path
# Full path
dbpath="/home/tester/edgex/db"
# Short path - no"/db/"
dirname="/home/tester/edgex"


clear
echo
echo "This script will do the following:"
echo "-- Ask you to supply a user name (consider \"<user>\" in /home/<user>) "
echo "---- The username is needed to set folder ownership."
echo "---- This username will not be the same username used for mongodb."
echo "---- The mongodb username will be supplied in the init_mongo.js file."
echo "-- Create folders, if necessary, for the database."
echo "-- Start database creation (without --auth). "
echo "-- Initialize the database for Edgex."
echo "-- Shutdown the database."
echo "-- Verify all processes of Mongo are stopped."
echo "-- Start the database again (using --auth). "
echo
echo

# Confirm the database folder location
echo "Should the folder for the database be created here: $dbpath "
echo
echo "Choose a number for your answer"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) echo; echo "Program exit. Edit the top of this shell file and run again"; exit;;
    esac
done
# Ask for a user name
echo
echo "What is the non-root user name who will own the folders where the database will be stored:"
echo

# read the non-root user name
read name
echo

# Confirm the user name
echo "Is this what you meant to write: $name "
echo
echo "Choose a number for your answer"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) echo; echo "progam exit, rerun again"; exit;;
    esac
done

# folder creation and change ownership
echo "Checking to see if $dbpath exist?"
echo
if [ ! -d $dbpath  ] 
then
    echo
    echo "The folder doesn't exist. "
    echo

    echo "Now creating $dbpath"
    sudo mkdir -p $dbpath
    echo

    echo "Folder created"
    echo

# DEBUG
#    echo "Who is the owner of the folder"
#    OWNS=$(stat -c '%U' $dbpath)
#    echo $OWNS
#    echo 

    echo "Changing the file owner to $name"
    sudo chown -R $name:$name $dirname
    echo
    echo "File owner changed"
    echo

# DEBUG
#    echo "Who is the owner of the folder"
#    OWNS=$(stat -c '%U' $dbpath)
#    echo $OWNS
#    echo

    echo "Folder creation is complete, moving to next step"
    echo

else
    echo "File exists -> moving to next step"
    echo
fi

# Start the database creation (without --auth)
sudo mongod --dbpath $dbpath
echo

# Initialize the database for edgex 
sudo mongo < init_mongo.js
echo

# Shutdown the database
sudo mongod --dbpath $dbpath --shutdown
echo

# Verify all the processes of Mongo are stopped
killpid=`sudo netstat -ntlp | grep mongod | awk '{print $7}' | sed 's/\/.*//'`
#echo This is the pid that needs to die: $killpid
sudo kill -9 $killpid
sudo netstat -tulnp | grep mongod

# Start the database (using --auth)
sudo mongod --dbpath $dbpath --auth
