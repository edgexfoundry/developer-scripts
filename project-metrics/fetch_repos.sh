repos=(ci-management
core-command
core-command-client
core-config-seed
core-config-watcher
core-data
core-data-client
core-domain
core-exception
core-metadata
core-metadata-client
core-test
developer-scripts
device-sdk
device-sdk-tools
device-virtual
docker-core-command
docker-core-config-seed
docker-core-consul
docker-core-data
docker-core-metadata
docker-device-virtual
docker-edgex-mongo
docker-edgex-mongo-seed
docker-edgex-volume
docker-support-logging
docker-support-notifications
docker-support-rulesengine
docker-support-scheduler
export-domain
export-test
edgex-ui-go
support-domain
support-logging
support-logging-client
support-notifications
support-notifications-client
support-rulesengine
support-scheduler
device-bacnet
device-bluetooth
device-fischertechnik
device-modbus
device-mqtt
device-snmp
device-domain
device-controller
device-sdk-go
device-sdk-c
blackbox-testing
export-go
consul-client-go
core-clients-go
core-command-go
core-data-go
core-domain-go
core-metadata-go
support-logging-client-go
support-notifications-client-go
support-domain-go
device-scheduling
edgex-go
core-config-seed-go
security-api-gateway
security-secret-store)


for repo in "${repos[@]}"
do
  #echo $repo
  if [ ! -d ./repos/$repo ]; then
      echo "Cloning $repo from https://github.com/edgexfoundry/$repo"
      git clone https://github.com/edgexfoundry/$repo ./repos/$repo
  else
      cd ./repos/$repo
      echo "Updating $repo"
      git checkout master && git fetch --all && git pull
      cd ../..
  fi;

  ### Uncomment/comment out as needed.
  #git checkout master && git fetch --all && git rebase upstream/master
  #git log --format='%aN'
  #git rev-list --count --no-merges HEAD
  #git log  | grep Author
  #git log --format='%aN' | sort -u | wc -l
  #echo "Total number of commits: $(git rev-list --count --no-merges HEAD)"
done
