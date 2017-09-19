Main Author: Jim White

Copyright 2016-17, Dell, Inc.

This repos contains scripts, batch files, JSON used in REST calls and other miscellaneous items used by developers buiding EdgeX.

## Running on Linux

For convenience there are a couple of scripts that help you get up and running 

### linux_setup.sh
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

This script works in two ways, you can download all modules in MODULES file or select one by one in case you only need a subset of modules.


### update-packages.sh

This script will update the installed packages in your working copy
