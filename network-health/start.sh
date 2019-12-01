#!/bin/bash

docker network create -d overlay --attachable healthNetwork

docker-compose -f ./compose-files/docker-compose-orderer.yml up -d

docker-compose -f ./compose-files/docker-compose-cli.yml up -d

#docker exec -it cli bash

# peer channel create -o orderer.healthcare.com:7050 -c healthchannel -f ./channel-artifacts/channel.tx

# peer channel join -b healthchannel.block

# export CORE_PEER_ADDRESS=peer1.hprovider.healthcare.com:7051

# peer channel join -b healthchannel.block

# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/research.healthcare.com/users/Admin@research.healthcare.com/msp/

# export CORE_PEER_ADDRESS=peer0.research.healthcare.com:7051

# export CORE_PEER_LOCALMSPID=ResearchMSP

# peer channel join -b healthchannel.block

# export CORE_PEER_ADDRESS=peer1.research.healthcare.com:7051

# peer channel join -b healthchannel.block

# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hprovider.healthcare.com/users/Admin@hprovider.healthcare.com/msp/

# export CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051

# export CORE_PEER_LOCALMSPID=HProviderMSP

# peer channel update -o orderer.healthcare.com:7050 -c healthchannel -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}-anchors.tx

# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/research.healthcare.com/users/Admin@research.healthcare.com/msp/

# export CORE_PEER_ADDRESS=peer0.research.healthcare.com:7051

# export CORE_PEER_LOCALMSPID=researchMSP

# peer channel update -o orderer.healthcare.com:7050 -c healthchannel -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx