## Edgex Docker Compose for `master` builds

This folder contains the docker compose files that pull and run the EdgeX images from the Nexus3 docker registry that are tagged `master`. These images are built from the Edgex CI Pipeline when PRs are merged into the `master` branch.

> *Note: Docker does not re-pull newer instances of these images. You must pull the new image instances. See the `make pull` command below that will do this for you.*

The approach used for these compose files is the `Extending using multiple Compose files` described here: https://docs.docker.com/compose/extends/#multiple-compose-files

The `Extending using multiple Compose files` approach along with environment files removes the majority of the duplication found in previous EdgeX compose files. This approach makes running the solution more complicated due to having to list the multiple compose files required to run a particular configuration. To help alleviate this complexity, a `Makefile`has been provided with commands that make it easy to run the multiple possible configurations. See the Makefile section below for details on these commands.

> *Note: The `make run`, `make pull` and `make gen` commands all generate a single `docker-compose.yml` file containing the content from the multiple compose files, environment files with all variables resolved for the specified options used. See below for list of options.*

### Compose Files

This folder contains the following compose files:

- **docker-compose-portainer.yml**
    Stand-alone compose file for running Portianer which is a  Docker container management tool. Visit here https://www.portainer.io/ for more details on Portianer.
- **docker-compose-nexus-base.yml**
    Base non-secure mode compose file. Contains all the services that run in the non-secure configuration.  
- **docker-compose-nexus-add-security.yml**
    Security **extending** compose file. Adds the additional security services and configuration of services so that all the services are running in the secure configuration.
- **docker-compose-nexus-add-device-services.yml**
    Device Service **extending** compose file. Adds the default **Device Virtual** and **Device REST** services with other device services commented out to be added by end user. Note: **Device MQTT** device service is in `docker-compose-nexus-add-mqtt.yml`
- **docker-compose-nexus-add-mqtt.yml**
    MQTT **extending** compose file. Adds a MQTT Broker and additional configuration of services so that the `MQTT` implementation of the Edgex Message Bus is used. Also adds the Device MQTT device service which is of course dependent on a MQTT Broker.
- **docker-compose-nexus-ui.yml**
    Stand-alone compose file for running the optional EdgeX UI. Runs in `host` network mode and only supports connecting to local Edgex services via 127.0.0.1 IP address.

### Environment Files

This folder contains the following environment files:

- **.env**
    This file contains the registry and image version variables referenced in compose files. Docker compose implicitly uses the ".env" file, if it exists, so you will not see it referenced in the compose files. It is referenced in the Makefile so that it can also use these settings.
- **common.env**
    This file contains the common environment overrides used by all Edgex services.
- **common-security.env**
    This file contains the common security related environment overrides used by many Edgex services.
- **database-security.env**
    This file contains the database specific security related environment overrides used by a few Edgex services.

### Makefile

This folder contains a `Makefile` that provides commands for running, stopping and cleaning the various EdgeX configurations.

```
Usage: make <target> where target is:
```
```
portainer       Runs Portainer independent of the EdgeX services
portainer-down	Stops Portainer independent of the EdgeX services
```
```
run [options] [services]
Runs the EdgeX services as specified by:
Options:
	no-secty:   Runs in Non-Secure Mode, otherwise runs in Secure Mode
	dev:        Runs using local dev built images from edgex-go repo's    `make docker`which creates docker images tagged with `master-dev`
	no-ds:      Runs without the default device services
	mqtt:       Runs using MQTT Message Bus and Device MQTT service
	arm64:      Runs using ARM64 images
	ui:         Runs only the EdgeX UI service. 'mqtt', 'no-ds' & 'no-secty' are ignored. Typically used after the other Edgex Services have been started
Services:
	<names...>: Runs only services listed (and their dependent services) where 'name' matches a service name in one of the compose files used
```
```				
pull [options] [services]
Pulls the EdgeX service images as specified :
Options:
	no-secty:   Pulls images for Non-Secure Mode, otherwise pull images for Secure Mode
	no-ds:      Pulls images without the default device services
	mqtt:       Pulls images including MQTT Message Bus and Device MQTT service
	arm64:      Pulls ARM64 version of images
	ui:         Pulls only the EdgeX UI service image. 'mqtt', 'no-ds' & 'no-secty' are ignored
Services:
	<names...>: Pulls only images for the service(s) listed
```
```	
gen [options]
Generates temporary single file compose file (`docker-compose.yml`) as specified by:
Options:
	no-secty:   Generates non-secure compose file, otherwise generates secure compose file
	dev:        Generates compose file using local dev built images from edgex-go repo's 'make docker'                       which creates docker images tagged with 'master-dev'
	no-ds:      Generates compose file without the default device services
	mqtt:       Generates compose file with MQTT Message Bus and Device MQTT service
	arm64:      Generates single file compose file using ARM64 images
	ui:         Generates single file compose file for only EdgeX UI, not useful, but possible
```
```
get-token [options] <user>
Generates a Kong access token for the specified `user` as specified by:
Options:
	dev:    Generates a Kong access token using local dev built docker image
			'make docker', which creates docker images tagged with 'master-dev'
	arm64:  Generates a Kong access token using ARM64 image
```
```    
del-token [options] <user>
Deletes a Kong access tokens for the specified 'user' as specified by:
Options:
    dev:    Deletes Kong access tokens using local dev built docker image
			'make docker', which creates docker images tagged with 'master-dev'
    arm64:  Deletes Kong access tokens using ARM64 image
```
```    
down
Stops all EdgeX service no matter which configuration started them
```
```
clean
Runs 'down' , then removes any stopped containers and then prunes unused volumes and networks
```


