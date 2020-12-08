#!/bin/sh

mkdir keys
openssl genpkey -algorithm RSA -out keys/rsa4096.key -pkeyopt rsa_keygen_bits:4096
openssl rsa -in keys/rsa4096.key -pubout -out keys/rsa4096.pub
JWT=`docker run --rm -it -e KONGURL_SERVER=kong --network edgex_edgex-network --entrypoint "" \
       -v ${PWD}/keys:/keys nexus3.edgexfoundry.org:10004/docker-security-proxy-setup-go:master \
        /edgex/secrets-config proxy adduser --token-type jwt --algorithm RS256 --public_key /keys/rsa4096.pub --user testinguser`
docker run --rm -it -e KONGURL_SERVER=kong --network edgex_edgex-network --entrypoint "" \
       -v ${PWD}/keys:/keys nexus3.edgexfoundry.org:10004/docker-security-proxy-setup-go:master \
       /edgex/secrets-config proxy jwt --algorithm RS256 --id ${JWT} --private_key /keys/rsa4096.key
rm -rf keys

