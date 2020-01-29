#!/bin/bash

CHANNEL_NAME=healthchannel
CONTRACT_PATH=/opt/gopath/src/github.com/chaincode/HRecords-contract
CONTRACT_NAME=HRecords-contract

CONFIG_ROOT=/opt/gopath/src/github.com/hyperledger/fabric/peer
HPROVIDER_MSPCONFIGPATH=${CONFIG_ROOT}/crypto-config/peerOrganizations/hprovider.healthcare.com/users/Admin@hprovider.healthcare.com/msp
HPROVIDER_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto-config/peerOrganizations/hprovider.healthcare.com/peers/peer0.hprovider.healthcare.com/tls/ca.crt
RESEARCH_MSPCONFIGPATH=${CONFIG_ROOT}/crypto-config/peerOrganizations/research.healthcare.com/users/Admin@research.healthcare.com/msp
RESEARCH_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto-config/peerOrganizations/research.healthcare.com/peers/peer0.research.healthcare.com/tls/ca.crt
ORDERER_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto-config/ordererOrganizations/healthcare.com/orderers/ordererhp.healthcare.com/msp/tlscacerts/tlsca.healthcare.com-cert.pem

CORE_PEER_TLS_ENABLED=true
ORDERER_CA=${CONFIG_ROOT}/crypto-config/ordererOrganizations/healthcare.com/orderers/ordererhp.healthcare.com/msp/tlscacerts/tlsca.healthcare.com-cert.pem

PEER0_HPROVIDER="docker exec
-e CORE_PEER_LOCALMSPID=HProviderMSP
-e CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051
-e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH}
-e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE}
cli
bash"

echo "Create channel ..."

docker exec -it -e CORE_PEER_LOCALMSPID=HProviderMSP -e CORE_PEER_ADDRESS=localhost:7051 -e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer channel create -o ordererhp.healthcare.com:7050 -c ${CHANNEL_NAME} -f ./channel-artifacts/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

sleep 2

#----------- Create Channel -------------

echo "join channel for peer0.hprovider ..."


docker exec  -e CORE_PEER_LOCALMSPID=HProviderMSP -e CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051 -e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer channel join -b ${CHANNEL_NAME}.block
#docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block

sleep 2

echo "join channel for peer1.hprovider ..."


docker exec  -e CORE_PEER_LOCALMSPID=HProviderMSP -e CORE_PEER_ADDRESS=peer1.hprovider.healthcare.com:8051 -e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer channel join -b ${CHANNEL_NAME}.block
#docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block 

sleep 2

echo "join channel for peer2.hprovider ..."


docker exec  -e CORE_PEER_LOCALMSPID=HProviderMSP -e CORE_PEER_ADDRESS=peer2.hprovider.healthcare.com:9051 -e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer channel join -b ${CHANNEL_NAME}.block
#docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block 

sleep 2

echo "join channel for peer3.hprovider ..."

docker exec  -e CORE_PEER_LOCALMSPID=HProviderMSP -e CORE_PEER_ADDRESS=peer3.hprovider.healthcare.com:10051 -e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer channel join -b ${CHANNEL_NAME}.block

sleep 2

echo "join channel for peer0.research ..."

docker exec  -e CORE_PEER_LOCALMSPID=ResearchMSP -e CORE_PEER_ADDRESS=peer0.research.healthcare.com:11051 -e CORE_PEER_MSPCONFIGPATH=${RESEARCH_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${RESEARCH_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer channel join -b ${CHANNEL_NAME}.block
#${PEER0_RESEARCH} \
#docker exec -it cli peer channel create -o ordererhp.healthcare.com:7050 -c ${CHANNEL_NAME} -f ./channel-artifacts/channel.tx \
#docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block 

sleep 2

echo "join channel for peer1.research ..."

docker exec  -e CORE_PEER_LOCALMSPID=ResearchMSP -e CORE_PEER_ADDRESS=peer1.research.healthcare.com:12051 -e CORE_PEER_MSPCONFIGPATH=${RESEARCH_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${RESEARCH_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer channel join -b ${CHANNEL_NAME}.block
#${PEER1_RESEARCH} \
#docker exec -it cli peer channel join -o ordererhp.healthcare.com:7050 -c ${CHANNEL_NAME} -f ./channel-artifacts/channel.tx \
#docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block 

sleep 2

echo "join channel for peer2.research ..."

docker exec  -e CORE_PEER_LOCALMSPID=ResearchMSP -e CORE_PEER_ADDRESS=peer2.research.healthcare.com:13051 -e CORE_PEER_MSPCONFIGPATH=${RESEARCH_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${RESEARCH_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer channel join -b ${CHANNEL_NAME}.block
#${PEER2_RESEARCH} \
#docker exec -it cli peer channel create -o ordererhp.healthcare.com:7050 -c ${CHANNEL_NAME} -f ./channel-artifacts/channel.tx \
#docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block 

sleep 2

echo "join channel for peer3.research ..."

docker exec  -e CORE_PEER_LOCALMSPID=ResearchMSP -e CORE_PEER_ADDRESS=peer3.research.healthcare.com:14051 -e CORE_PEER_MSPCONFIGPATH=${RESEARCH_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${RESEARCH_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer channel join -b ${CHANNEL_NAME}.block

sleep 2

#------------------Install--------------------

echo "Installing chaincode for peer0.hprovider ..."

docker exec  -e CORE_PEER_LOCALMSPID=HProviderMSP -e CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051 -e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}
#${PEER0_HPROVIDER} \
#docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

sleep 2

echo "Installing chaincode for peer1.hprovider ..."

docker exec  -e CORE_PEER_LOCALMSPID=HProviderMSP -e CORE_PEER_ADDRESS=peer1.hprovider.healthcare.com:8051 -e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}
#${PEER1_HPROVIDER} \
#docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

sleep 2

echo "Installing chaincode for peer2.hprovider ..."

docker exec  -e CORE_PEER_LOCALMSPID=HProviderMSP -e CORE_PEER_ADDRESS=peer2.hprovider.healthcare.com:9051 -e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}
#${PEER2_HPROVIDER} \
#docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

sleep 2

echo "Installing chaincode for peer3.hprovider ..."

docker exec  -e CORE_PEER_LOCALMSPID=HProviderMSP -e CORE_PEER_ADDRESS=peer3.hprovider.healthcare.com:10051 -e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

sleep 2

echo "Installing chaincode for peer0.research ..."

docker exec  -e CORE_PEER_LOCALMSPID=ResearchMSP -e CORE_PEER_ADDRESS=peer0.research.healthcare.com:11051 -e CORE_PEER_MSPCONFIGPATH=${RESEARCH_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${RESEARCH_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}
#${PEER0_RESEARCH} \
#docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

sleep 2

echo "Installing chaincode for peer1.research ..."

docker exec  -e CORE_PEER_LOCALMSPID=ResearchMSP -e CORE_PEER_ADDRESS=peer1.research.healthcare.com:12051 -e CORE_PEER_MSPCONFIGPATH=${RESEARCH_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${RESEARCH_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}
#${PEER1_RESEARCH} \
#docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

sleep 2

echo "Installing chaincode for peer2.research ..."

docker exec  -e CORE_PEER_LOCALMSPID=ResearchMSP -e CORE_PEER_ADDRESS=peer2.research.healthcare.com:13051 -e CORE_PEER_MSPCONFIGPATH=${RESEARCH_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${RESEARCH_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}
#${PEER2_RESEARCH} \
#docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

sleep 2

echo "Installing chaincode for peer3.research ..."

docker exec  -e CORE_PEER_LOCALMSPID=ResearchMSP -e CORE_PEER_ADDRESS=peer3.research.healthcare.com:14051 -e CORE_PEER_MSPCONFIGPATH=${RESEARCH_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${RESEARCH_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

sleep 2

#---------- Instatiate chaincode ------------------

echo "Instatiate chaincode peer0.hprovider..."

docker exec  -e CORE_PEER_LOCALMSPID=HProviderMSP -e CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051 -e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE} -e CORE_PEER_TLS_ENABLED=${CORE_PEER_TLS_ENABLED} -e ORDERER_CA=${ORDERER_CA} cli peer chaincode instantiate -o ordererhp.healthcare.com:7050 -C ${CHANNEL_NAME} -l node -n ${CONTRACT_NAME} -v 1.0 -c '{"Args":[]}'
#docker exec -it cli peer chaincode instantiate -o ordererhp.healthcare.com:7050 -C ${CHANNEL_NAME} -l node -n ${CONTRACT_NAME} -v 1.0 -c '{"Args":[]}'

sleep 2

${PEER0_HPROVIDER}

docker exec -it cli peer chaincode invoke -o ordererhp.healthcare.com:7050 -C ${CHANNEL_NAME} -n ${CONTRACT_NAME} -c '{"Args":["createHealthcareLabs", "1003", "1001","1001","erikson","Labs Records","1217212121"]}'
