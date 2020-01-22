#!/bin/bash

CHANNEL_NAME=healthchannel

docker-compose -f docker-compose.yaml down
docker-compose -f docker-compose.yaml up -d

docker exec -it cli peer channel create -o ordererhp.healthcare.com:7050 -c healthchannel -f ./channel-artifacts/channel.tx

docker exec -it cli peer channel join -b healthchannel.block



docker exec -it cli -e CORE_PEER_ADDRESS=peer1.hprovider.healthcare.com:7051 

docker exec -it cli peer channel join -b healthchannel.block


docker exec -it -e CORE_PEER_ADDRESS=peer2.hprovider.healthcare.com:7051 cli

docker exec -it cli peer channel join -b healthchannel.block



docker exec -it -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/research.healthcare.com/users/Admin\@research.healthcare.com/msp/ cli

docker exec -it -e CORE_PEER_LOCALMSPID=ResearchMSP cli


docker exec -it -e CORE_PEER_ADDRESS=peer0.research.healthcare.com:7051 cli

docker exec -it cli peer channel join -b healthchannel.block

docker exec -it -e CORE_PEER_ADDRESS=peer1.research.healthcare.com:7051 cli

docker exec -it cli peer channel join -b healthchannel.block

docker exec -it -e CORE_PEER_ADDRESS=peer2.research.healthcare.com:7051 cli

docker exec -it cli peer channel join -b healthchannel.block


docker exec -it -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/hprovider.healthcare.com/users/Admin\@hprovider.healthcare.com/msp/ cli

docker exec -it -e CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051 cli

docker exec -it -e CORE_PEER_LOCALMSPID=HProviderMSP cli

docker exec -it cli peer channel update -o ordererhp.healthcare.com:7050 -c healthchannel -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}-anchors.tx

docker exec -it -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/research.healthcare.com/users/Admin\@research.healthcare.com/msp/ cli

docker exec -it -e CORE_PEER_ADDRESS=peer0.research.healthcare.com:7051 cli

docker exec -it -e CORE_PEER_LOCALMSPID=ResearchMSP cli

docker exec -it cli peer channel update -o ordererhp.healthcare.com:7050 -c healthchannel -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}-anchors.tx