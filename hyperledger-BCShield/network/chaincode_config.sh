#!/bin/bash

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/hprovider.healthcare.com/users/Admin\@hprovider.healthcare.com/msp/

export CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051

export CORE_PEER_LOCALMSPID=HProviderMSP

peer chaincode install -n Healthcare-records -v 1.0 -l golang -p /opt/gopath/src/github.com/chaincode/Healthcare-records

export CORE_PEER_ADDRESS=peer1.hprovider.healthcare.com:7051

peer chaincode install -n Healthcare-records -v 1.0 -l go -p /opt/gopath/src/github.com/chaincode/Healthcare-records

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/reseach.healthcare.com/users/Admin\@reseach.healthcare.com/msp/

export CORE_PEER_ADDRESS=peer0.reseach.healthcare.com:7051

export CORE_PEER_LOCALMSPID=ReseachMSP

peer chaincode install -n Healthcare-records -v 1.0 -l go -p /opt/gopath/src/github.com/chaincode/Healthcare-records

export CORE_PEER_ADDRESS=peer1.reseach.healthcare.com:7051

peer chaincode install -n Healthcare-records -v 1.0 -l go -p /opt/gopath/src/github.com/chaincode/Healthcare-records

peer chaincode instantiate -o ordererhp.healthcare.com:7050 -C healthchannel -l go -n Healthcare-records -v 1.0 -c '{"Args":[]}'

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/hprovider.healthcare.com/users/Admin\@hprovider.healthcare.com/msp/

export CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051

export CORE_PEER_LOCALMSPID=HProviderMSP

peer chaincode invoke -n Healthcare-records -c '{"Args":["123", "Product one", "10"], "Function":"registerProduct"}' -C healthchannel

peer chaincode query -n Healthcare-records -c '{"Args":["123"], "Function":"getProduct"}' -C healthchannel
