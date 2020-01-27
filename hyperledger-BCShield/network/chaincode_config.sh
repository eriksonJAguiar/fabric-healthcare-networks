#!/bin/bash

docker exec -it -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/hprovider.healthcare.com/users/Admin\@hprovider.healthcare.com/msp/ cli

docker exec -it -e  CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051 cli

docker exec -it -e  CORE_PEER_LOCALMSPID=HProviderMSP cli

docker exec -it cli peer chaincode install -n Health_DICOM -v 1.0 -l golang -p github.com/chaincode/Health_DICOM
#peer chaincode install -n HRecordes-contract -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/HRecords-contract

docker exec -it -e CORE_PEER_ADDRESS=peer1.hprovider.healthcare.com:7051 cli
peer chaincode install -n HRecordes-contract -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/HRecords-contract

docker exec -it -e CORE_PEER_ADDRESS=peer2.hprovider.healthcare.com:7051 cli
peer chaincode install -n HRecordes-contract -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode/HRecords-contract

docker exec -it cli peer chaincode install -n Health_DICOM -v 1.0 -l golang -p github.com/chaincode/Health_DICOM

docker exec -it -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/research.healthcare.com/users/Admin\@research.healthcare.com/msp/ cli

docker exec -it -e CORE_PEER_ADDRESS=peer0.research.healthcare.com:7051 cli

docker exec -it -e CORE_PEER_LOCALMSPID=ResearchMSP cli

docker exec -it cli peer chaincode install -n Health_DICOM -v 1.0 -l golang -p github.com/chaincode/Health_DICOM

docker exec -it -e CORE_PEER_ADDRESS=peer1.research.healthcare.com:7051 cli

docker exec -it cli peer chaincode install -n Health_DICOM -v 1.0 -l golang -p github.com/chaincode/Health_DICOM

docker exec -it cli peer chaincode instantiate -o ordererhp.healthcare.com:7050 -C healthchannel -l golang -n Health_DICOM -v 1.0 -c '{"Args":[]}'
#/opt/gopath/src/github.com/chaincode/HRecordes-contract
#peer chaincode instantiate -o ordererhp.healthcare.com:7050 -C healthchannel -l node -n HRecordes-contract -v 1.0 -c '{"Args":[]}'

docker exec -it -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/hprovider.healthcare.com/users/Admin\@hprovider.healthcare.com/msp/ cli

docker exec -it -e CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051 cli

docker exec -it -e CORE_PEER_LOCALMSPID=HProviderMSP cli

peer chaincode invoke -n Health_DICOM -c '{"Args":["123", "222", "Running", "100", "-1828192 121212"], "Function":"initRecord"}' -C healthchannel
#peer chaincode invoke -n HRecordes-contract -c '{"Args":['1003', '1001','1001','erikson','Labs Records','1217212121'], "Function":"createHealthcareLabs"}' -C healthchannel
#docker exec -it cli peer chaincode invoke -o ordererhp.healthcare.com:7050 -C healthchannel -n HRecordes-contract --peerAddresses peer0.hprovider.healthcare.com:7051 --peerAddresses peer0.research.healthcare.com:7051 -c '{"Args":["createHealthcareLabs", "1003", "1001","1001","erikson","Labs Records","1217212121"]}'
#docker exec -it cli peer chaincode invoke -o ordererhp.healthcare.com:7050 -C healthchannel -n HRecords-contract -c '{"Args":["createHealthcareLabs", "1003", "1001","1001","erikson","Labs Records","1217212121"]}'

peer chaincode query -n HRecords-contract -c '{"Args":["123"], "Function":"readHealthcareLabs"}' -C healthchannel
#peer chaincode query -n HRecordes-contract -c '{"Args":["readRecord","1003"], "Function":}' -C healthchannel