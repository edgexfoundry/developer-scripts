## Edgex Docker Compose for `master` builds

This folder contains the docker compose files that pull and run the EdgeX images from the Nexus3 docker registry that are tagged with `master`. These images are built from the Edgex CI Pipeline when PRs are merged into the `master` branch.

> *Note: Docker does not re-pull newer instances of these images. You must pull the new image instances. See the `make pull` command described below that will do this for you.*

These compose files are auto generated from the multiple files contained in the `source` folder. See [README](./source/README.md) there for details on regenerating these files after making changes. 

### Compose Files

This folder contains the following compose files:

#### Generated Compose files

> **NOTES: **
>
> - *DO NOT EDIT the files directly for permanent changes. Make all permanent changes to the source compose files in the `source` folder and then regenerate these files*
> - Use `make build-all` to regenerate all the following compose files.
> - See each description for the convenience `make` commands that are provided to work with that compose file.

- **docker-compose-nexus.yml**
    Contains all the services required to run in secure configuration. 
    **Make Commands** 
    
     - Use `make run <service(s)>` and `make down` to start and stop the services using this compose file.
    
     - Use `make pull <service(s)>` to pull all or some images for the services in this compose file.
    
     - Use `make get-token` to generate a Kong access token for remote access of the services running from this compose file.
    
- **docker-compose-nexus-arm64.yml**
    Contains all the services required to run in secure configuration on `ARM64` system. 
    **Make Commands** 
    
     - Use `make run arm64` and `make down` to start and stop the services using this compose file.
     - Use `make pull arm64 <service(s)>` to pull all or some images for the services in this compose file.
     - Use `make get-token arm64` to generate a Kong access token for remote access of the services running from this compose file.
    
- **docker-compose-nexus-no-secty.yml**
    Contains just the services needed to run in non-secure configuration. 
    **Make Commands**

    - Use `make run no-secty` and `make down` to start and stop the services using this compose file.
    - Use `make pull no-secty <service(s)>` to pull all or some images for the services in this compose file.
    
- **docker-compose-nexus-no-secty-arm64.yml**
    Contains just the services needed to run in non-secure configuration on `ARM64` system. 
    
    **Make Commands**
    
    - Use `make run no-secty arm64` and `make down` to start and stop the services using this compose file.
    - Use `make pull no-secty arm64 <service(s)>` to pull all or some images for the services in this compose file.
    
- **docker-compose-nexus-ui.yml**
    Stand-alone compose file for running the optional EdgeX UI.
    **Make Commands**
    
    - Use `make run-ui` and `make down-ui` to start and stop the UI using this compose file.
    - Use `make pull-ui ` to pull image for the UI service in this compose file.
    
- **docker-compose-nexus-ui-arm64.yml**
    Stand-alone compose file for running the optional EdgeX UI on `ARM64` system.
    
    **Make Commands**
    
    - Use `make run-ui arm64` and `make down-ui arm64` to start and stop the UI using this compose file.
    - Use `make pull-ui arm64`  to pull image for the UI service in this compose file.

### Additional make commands

- `make build`
Regenerates (aka builds) all the docker compose file variations from the source compose files located in the `source` directory.
    
- `make clean`

    Runs `down` commands, removes all stopped container and prunes all unused volumes and networks. Use this command when needing to do a fresh restart.

### Additional compose files

- **docker-compose-portainer.yml**
    Stand-alone compose file for running Portianer which is a  Docker container management tool. Visit here https://www.portainer.io/ for more details on Portianer.
    Use `make portianer`and `make portianer-down` to start and stop Portianer.
