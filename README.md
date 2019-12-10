# Developer Scripts

Main Author: Jim White

Copyright 2016-17, Dell, Inc.

This repos contains scripts, batch files, JSON used in REST calls and other miscellaneous items used by developers buiding EdgeX.

## Running on Linux

For convenience there are a couple of scripts that help you get up and running

### Run this First

**linux_setup.sh**, this script assumes:

* you are starting with a fresh install of mongodb
* that init_mongo.js has not been run before  

This script will:

* create the necessary folder(s) for database placement
* start mongod without the "--auth" option
* initialize the mongo database (via init_mongo.js)
* restart mongod with the "--auth" option
* leave mongo in a state of waiting for a connection.

### Run This Second

**prepare-environment.sh**, this script will clone the set of modules you need. You can pass a list of valid modules.

>MODULES: core-data-client core-domain core-exception core-test 
>export-domain export-test support-domain support-logging-client 
>support-notifications-client core-data core-metadata-client

**Note**, if you run the script without parameters, you can manually choose which modules you want to be installed.

### Running EdgeX

**run-it.sh**, this script will start the services
in order as described [HERE](https://docs.edgexfoundry.org/Ch-GettingStartedUsers.html).

### Updating EdgeX

**update-packages.sh**, this script will update the installed packages in your working copy

### Reset

**reset-dockers.sh**, this script removes all containers and images from your environment. Very useful for development, when you want to reset everything from scratch

### Containerization

**create-containers.sh**, this script creates containers and images defined in the environment variable `DOCKERS`
