#!/bin/bash

# Shell script to start mongod

clear

echo # blank line for screen output
echo The mongo database will be located here: /home/edgex/db
echo # blank line for screen output
echo Starting mongo
echo # blank line for screen output
#
# The first time that you start the db do not run with "--auth"
#
#mongod --dbpath /home/edgex/db
#sudo netstat -ntlp | grep 27017
#sudo netstat -ntlp | grep 1401 | awk '{print $7}' | sed 's/\/.*//'

#sudo netstat -tulnp | grep 1401


#killpid=`sudo netstat -ntlp | grep 1401 | awk '{print $7}' | sed 's/\/.*//'`
#echo This is the pid that needs to die: $killpid
#sudo kill -9 $killpid
#sudo netstat -tulnp | grep 1401







