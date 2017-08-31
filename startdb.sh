#!/bin/bash

# Shell script to start mongod

clear

echo # blank line for screen output
echo The mongo database will be located here: /home/$USER/mongodb/db
echo # blank line for screen output
echo Starting mongo
echo # blank line for screen output
#
# The first time that you start the db do not run with "--auth"
#
#mongod --dbpath /home/$USER/mongodb/db

#
# The first time that you start the db you will use "--auth"
#
 mongod --dbpath /home/$USER/mongodb/db --auth
