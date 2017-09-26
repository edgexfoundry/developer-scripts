Main Author: Jim White

Copyright 2016-17, Dell, Inc.

This repos contains scripts, batch files, JSON used in REST calls and other miscellaneous items used by developers buiding EdgeX.

## Running on Linux

For convenience there are a couple of scripts that help you get up and running

### linux_setup.sh
This script assumes:
* you are starting with a fresh install of mongodb
* that init_mongo.js has not been run before  

This script will:
* create the necessary folder(s) for database placement
* start mongod without the "--auth" option
* initialize the mongo database (via init_mongo.js)
* restart mongod with the "--auth" option
* leave mongo in a state of waiting for a connection.

### run-it.sh
This script will start the services
in order as described [HERE](https://wiki.edgexfoundry.org/display/FA/Get+EdgeX+Foundry+-+Users).


### prepare-environment.sh

This script is used to clone from each git, the set of modules you need. You can pass a list of valid modules.

>MODULES: core-data-client core-domain core-exception core-test export-distro 
>export-domain export-test support-domain support-logging-client export-client
>support-notifications-client core-data core-metadata-client

Also, if you run the script without parameters, you can choose manually which one of above do you want to be installed.


### update-packages.sh

This script will update the installed packages in your working copy

### reset-dockers.sh

This script removes all containers and images from your environment. Very useful for development

### create-containers.sh

This script creates containers and images defined in internal variable `DOCKER`
