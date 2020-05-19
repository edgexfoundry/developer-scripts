## Edgex Docker Compose for `master` builds

This folder contain the docker compose files that pull and run the EdgeX images from the Nexus3 docker registry that are tagged `master`. These images are build from the Edgex CI Pipeline when PRs are merged into the `master` branch.

> *Note: Docker does not re-pull newer instances of these images. You must explicitly remove old instances so the new instances are pulled. See the `make remove` command below that will do this for you.*

These approach used for these compose files is the `Extending using multiple Compose files` described here: https://docs.docker.com/compose/extends/#multiple-compose-files

The `Extending using multiple Compose files` approach removes the majority of the duplication in the multiple composes file that previous Edgex release compose file endure. This approach does make actual running of the solution more complicated due to having to list the multiple compose file required to run a particular configuration. To help alleviate this complexity, a `Makefile`has been provided with commands that make it easy to run the multiple possible configurations. See the Makefile section below for details on these commands

### Compose Files

This folder contains the following compose files:

| Name                                  | Description                                                  |
| ------------------------------------- | ------------------------------------------------------------ |
| docker-compose-portainer.yml          | Stand-alone compose file for running Portianer which is a  Docker container management tool. Got here https://www.portainer.io/ for more details on Portianer. |
| docker-compose-nexus-base.yml         | Base non-secure mode compose file. <br />Contains all the services that run in the non-secure configuration. |
| docker-compose-nexus-add-security.yml | Security **extending** compose file.<br />Adds the additional security services and configuration of services so that all the services are running in the secure configuration. |
| docker-compose-nexus-add-mqtt.yml     | MQTT **extending** compose file.<br />Adds a MQTT Broker and additional configuration of services so that the `MQTT` implementation of the Edgex Message Buss is used.<br />Also adds the Device MQTT device service which is of course dependent on a MQTT Broker. |
| docker-compose-nexus-ui.yml           | Stand-alone compose file for running the optional EdgeX UI. Runs in `host` network mode and only supports connecting to local Edgex services via 127.0.0.1 IP address. |

### Makefile

This folder contains a `Makefile` that provides helper commands for running, stopping and cleaning the various EdgeX configurations.

| Command                  | Description                                                  |
| ------------------------ | ------------------------------------------------------------ |
| make portainer           | Runs **`Portainer`** independent of the EdgeX services       |
| make portainer-down      | Stops **`Portainer`** independent of the EdgeX services      |
| make run                 | Runs the EdgeX services in **secure mode**                   |
| make run-no-sec          | Runs the EdgeX services in **non-secure mode**               |
| make run-mqtt            | Runs the EdgeX services using MQTT Message Buss in **secure mode**, including the Device MQTT service. |
| make run-mqtt-no-sec     | Runs the EdgeX services using MQTT Message Buss in **non-secure** mode, including the Device MQTT service. |
| make run-ui              | Runs the optional EdgeX UI service.                          |
| make run-arm             | Runs the **ARM64** EdgeX services in **secure mode**         |
| make run-arm-no-sec      | Runs the **ARM64** EdgeX services in **non-secure mode**     |
| make run-mqtt-arm        | Runs the **ARM64** EdgeX services using MQTT Message Buss in **secure mode**, including the Device MQTT service. |
| make run-mqtt-arm-no-sec | Runs the **ARM64** EdgeX services using MQTT Message Buss in **non-secure** mode, including the Device MQTT service. |
| make run-ui-arm          | Runs the optional **ARM64** EdgeX UI service.                |
| make down                | Stops all EdgeX no matter which configuration they are running in. |
| make clean               | Runs **`down`** and then removes any stopped containers, prunes unused volumes and networks |
| make remove              | Runs **`clean`** and then removes all docker images with the **`master`** tag. This is how you make sure you are using the very latest **`master`** images. It is highly recommended to run this command prior to any validation of you current pull request. |

