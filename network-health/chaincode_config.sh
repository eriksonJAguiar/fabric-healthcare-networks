#!/bin/bash

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/hprovider.healthcare.com/users/Admin\@hprovider.healthcare.com/msp/

export CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051

export CORE_PEER_LOCALMSPID=HProviderMSP

#peer chaincode install -n Health_DICOM -v 1.0 -l golang -p github.com/chaincode/Health_DICOM

#export CORE_PEER_ADDRESS=peer1.hprovider.healthcare.com:7051

peer chaincode install -n Health_DICOM -v 1.0 -l golang -p github.com/chaincode/Health_DICOM

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/research.healthcare.com/users/Admin\@research.healthcare.com/msp/

export CORE_PEER_ADDRESS=peer0.research.healthcare.com:7051

export CORE_PEER_LOCALMSPID=ResearchMSP

peer chaincode install -n Health_DICOM -v 1.0 -l golang -p github.com/chaincode/Health_DICOM

#export CORE_PEER_ADDRESS=peer1.research.healthcare.com:7051

peer chaincode install -n Health_DICOM -v 1.0 -l golang -p github.com/chaincode/Health_DICOM

peer chaincode instantiate -o ordererhp.healthcare.com:7050 -C healthchannel -l golang -n Health_DICOM -v 1.0 -c '{"Args":[]}'

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/hprovider.healthcare.com/users/Admin\@hprovider.healthcare.com/msp/

export CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051

export CORE_PEER_LOCALMSPID=HProviderMSP

#peer chaincode invoke -n Health_DICOM -c '{"Args":["123", "222", "Running", "100", "-1828192 121212"], "Function":"initRecord"}' -C healthchannel

#peer chaincode query -n Health_DICOM -c '{"Args":["123"], "Function":"readRecord"}' -C healthchannel
