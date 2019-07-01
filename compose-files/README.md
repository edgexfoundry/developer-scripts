# last updated:  12/11/2018

## Docker Compose Files
This folder contains Docker Compose files for the following releases and usages:
* docker-compose-edinburgh-1.0.0.yml: This file uses the EdgeX **Edinburgh release 1.0.0** container images
* docker-compose-edinburgh-no-secty-1.0.0.yml: This file uses the EdgeX **Edinburgh release 1.0.0** container images and does not include security services.
* docker-compose-redis-edinburgh-1.0.0.yml: This file uses the EdgeX **Edinburgh release 1.0.0** container images. See Note 8.
* docker-compose-redis-edinburgh-no-secty-1.0.0.yml: This file uses the EdgeX **Edinburgh release 1.0.0** container images and does not include security services.  See Note 8.
* docker-compose-redis-delhi-0.7.1.yml: This file uses the EdgeX **Delhi release 0.7.1** container images.  See Note 7.
* docker-compose-delhi-0.7.1.yml:       This file uses the EdgeX **Delhi release 0.7.1** container images.  See Note 6.
* docker-compose-delhi-0.7.0.yml:       This file uses the EdgeX **Delhi release 0.7.0** container images.
* docker-compose-california-0.6.1.yml:  This file uses the EdgeX **California release 0.6.1** container images.  See Note 5.
* docker-compose-california-0.6.0.yml:  This file uses the EdgeX **California release 0.6.0** container images.
* docker-compose-california-0.5.2.yml:  This file includes mid-way versions of the Go core, support and export services with the latest Nexus container images.  It is meant as a develoment/testing copy of EdgeX.
* docker-compose-barcelona-0.2.0.yml:   This file uses the EdgeX **Barcelona release 0.2.0** container images.  See Note 1
* docker-compose-barcelona-0.2.1.yml:   This file uses the EdgeX **Barcelona release 0.2.1** container images.  Release 0.2.1 was a bug fix release to version 0.2.0.  See Note 2
* docker-compose-nexus.yml:             This file uses the latest EdgeX container images from the EdgeX Nexus repository managed by the Linux Foundation. See Note 3
* docker-compose-nexus-no-secty.yml:    This file uses the latest EdgeX container images and does not include security services from the EdgeX Nexus repository managed by the Linux Foundation. See Note 3

## Notes
1. The Barcelona 0.2 release of EdgeX has an issue whereby the health check address for each of the microservices was not set correctly.  The release will still run and perform its duties, but Consul will not be able to apprpriately know the status of all the services.
2. Some of the 0.2.1 release containers did not require a fix and are left at version 0.2.0
3. Using this Docker Compose will require you have access to the EdgeX Nexus repository.  See https://wiki.edgexfoundry.org/display/FA/Getting+Docker+Images+from+EdgeX+Nexus+Repository
4. Note that all the Docker Compose files have device service elements that have all been commented out (except for the device-virtual).  Uncomment the sections for the device services you need.
5. This release was a minor revision of the California release.  It includes the new Go notification micro service and some bug fixes (including a correction to rules engine).
6. This release includes Redis persistence implementation for core data, metadata and logging and some bug fixes.
7. This is the Delhi 0.7.1 release with the addition of the Redis container (for use when using Redis in persistence with core data, metadata or logging).
7. This is the Edinburgh 1.0.0 release with the addition of the Redis container (for use when using Redis in persistence with core data, metadata or logging).

## Donations
Other members of the community that are creating unique, updated or special EdgeX deployments are invited to add their Docker Compose files to this folder.  When contributing, please use the following naming conventions:
docker-compose-[release name or organization]-[purpose if applicable]-[version if applicable].yml

For example:
* docker-compose-dell-WithDellUIs.yml
* docker-compose-samsung-smartfactory-1.1.yml
