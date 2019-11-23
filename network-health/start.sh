#!/bin/bash

docker-compose -f ./compose-files/docker-compose-orderer.yml up -d

docker-compose -f ./compose-files/docker-compose-node1.yml up -d

# docker exec -it -e CHANNEL_NAME=healthchannel cli

# docker exec -it -e ORG=hprovider.healthcare.com cli

# docker exec -it cli peer channel create -o orderer0.${ORG}:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/$ORG/orderers/orderer0.${ORG}/msp/tlscacerts/tlsca.${ORG}-cert.pem