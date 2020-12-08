#!/bin/sh

# DEV and ARCH are set in environment prior to calling script
# example: DEV=-dev ARCH=-arm64 ./get-api-gateway-token.sh

# versions are loaded from .env file
. ./.env

if [ "$DEV" = "-dev" ]; then
  CORE_EDGEX_VERSION=0.0.0
fi

rm -rf keys
mkdir keys
openssl genpkey -algorithm RSA -out keys/rsa4096.key -pkeyopt rsa_keygen_bits:4096 2> /dev/null
openssl rsa -in keys/rsa4096.key -pubout -out keys/rsa4096.pub 2> /dev/null
ID=`uuidgen`
docker run --rm -it -e KONGURL_SERVER=kong --network edgex_edgex-network --entrypoint "" -v ${PWD}/keys:/keys \
       ${CORE_EDGEX_REPOSITORY}/docker-security-proxy-setup-go${ARCH}:${CORE_EDGEX_VERSION}${DEV} \
        /edgex/secrets-config proxy adduser --token-type jwt --id ${ID} --algorithm RS256 --public_key /keys/rsa4096.pub --user testinguser > /dev/null
docker run --rm -it -e KONGURL_SERVER=kong --network edgex_edgex-network --entrypoint "" -v ${PWD}/keys:/keys \
       ${CORE_EDGEX_REPOSITORY}/docker-security-proxy-setup-go${ARCH}:${CORE_EDGEX_VERSION}${DEV} \
       /edgex/secrets-config proxy jwt --algorithm RS256 --id ${ID} --private_key /keys/rsa4096.key
rm -rf keys

