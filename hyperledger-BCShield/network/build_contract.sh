#!/bin/bash

CHANNEL_NAME=healthchannel
CONTRACT_PATH=/opt/gopath/src/github.com/chaincode/HRecordes-contract
CONTRACT_NAME=HRecordes-contract

CONFIG_ROOT=/opt/gopath/src/github.com/hyperledger/fabric/peer
HPROVIDER_MSPCONFIGPATH=${CONFIG_ROOT}/crypto/peerOrganizations/hprovider.healthcare.com/users/Admin@hprovider.healthcare.com/msp
HPROVIDER_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/hprovider.healthcare.com/peers/peer0.hprovider.healthcare.com/tls/ca.crt
RESEARCH_MSPCONFIGPATH=${CONFIG_ROOT}/crypto/peerOrganizations/research.healthcare.com/users/Admin@research.healthcare.com/msp
RESEARCH_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/research.healthcare.com/peers/peer0.research.healthcare.com/tls/ca.crt
ORDERER_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/ordererOrganizations/healthcare.com/orderers/ordererhp.healthcare.com/msp/tlscacerts/tlsca.healthcare.com-cert.pem


PEER0_HPROVIDER="docker exec
-e CORE_PEER_LOCALMSPID=HProviderMSP
-e CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051
-e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH}
-e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE}
cli
bash"

docker exec  -e CORE_PEER_LOCALMSPID=HProviderMSP -e CORE_PEER_ADDRESS=peer0.hprovider.healthcare.com:7051 -e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH} -e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE} cli


PEER1_HPROVIDER="docker exec
-e CORE_PEER_LOCALMSPID=HProviderMSP
-e CORE_PEER_ADDRESS=peer1.hprovider.healthcare.com:7056
-e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH}
-e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE}
cli
bash"


PEER2_HPROVIDER="docker exec
-e CORE_PEER_LOCALMSPID=HProviderMSP
-e CORE_PEER_ADDRESS=peer2.hprovider.healthcare.com:7061
-e CORE_PEER_MSPCONFIGPATH=${HPROVIDER_MSPCONFIGPATH}
-e CORE_PEER_TLS_ROOTCERT_FILE=${HPROVIDER_TLS_ROOTCERT_FILE}
cli
bash"

PEER0_RESEARCH="docker exec
-e CORE_PEER_LOCALMSPID=ResearchMSP
-e CORE_PEER_ADDRESS=peer0.research.healthcare.com:7071
-e CORE_PEER_MSPCONFIGPATH=${RESEARCH_MSPCONFIGPATH}
-e CORE_PEER_TLS_ROOTCERT_FILE=${RESEARCH_TLS_ROOTCERT_FILE}
cli
bash"

PEER1_RESEARCH="docker exec
-e CORE_PEER_LOCALMSPID=ResearchMSP
-e CORE_PEER_ADDRESS=peer1.research.healthcare.com:7075
-e CORE_PEER_MSPCONFIGPATH=${RESEARCH_MSPCONFIGPATH}
-e CORE_PEER_TLS_ROOTCERT_FILE=${RESEARCH_TLS_ROOTCERT_FILE}
cli
bash"

PEER1_RESEARCH="docker exec
-e CORE_PEER_LOCALMSPID=ResearchMSP
-e CORE_PEER_ADDRESS=peer1.research.healthcare.com:7081
-e CORE_PEER_MSPCONFIGPATH=${RESEARCH_MSPCONFIGPATH}
-e CORE_PEER_TLS_ROOTCERT_FILE=${RESEARCH_TLS_ROOTCERT_FILE}
cli
bash"


docker exec -it cli peer channel create -o ordererhp.healthcare.com:7050 -c ${CHANNEL_NAME} -f ./channel-artifacts/channel.tx

#----------- Create Channel -------------

echo "create channel for peer0.hprovider ..."


${PEER0_HPROVIDER} \
docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block


echo "create channel for peer1.hprovider ..."


${PEER1_HPROVIDER} \

docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block 

echo "create channel for peer2.hprovider ..."


${PEER2_HPROVIDER} \
docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block 


echo "create channel for peer0.research ..."

${PEER0_RESEARCH} \
docker exec -it cli peer channel create -o ordererhp.healthcare.com:7050 -c ${CHANNEL_NAME} -f ./channel-artifacts/channel.tx \
docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block 


echo "create channel for peer1.research ..."

${PEER1_RESEARCH} \
docker exec -it cli peer channel create -o ordererhp.healthcare.com:7050 -c ${CHANNEL_NAME} -f ./channel-artifacts/channel.tx \
docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block 


echo "create channel for peer2.research ..."

${PEER2_RESEARCH} \
docker exec -it cli peer channel create -o ordererhp.healthcare.com:7050 -c ${CHANNEL_NAME} -f ./channel-artifacts/channel.tx \
docker exec -it cli peer channel join -b ${CHANNEL_NAME}.block 


#------------------Install--------------------

echo "Installing chaincode for peer0.hprovider ..."

${PEER0_HPROVIDER} \
docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}


echo "Installing chaincode for peer1.hprovider ..."

${PEER1_HPROVIDER} \
docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

echo "Installing chaincode for peer2.hprovider ..."

${PEER2_HPROVIDER} \
docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}


echo "Installing chaincode for peer0.research ..."

${PEER0_RESEARCH} \
docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

echo "Installing chaincode for peer1.research ..."

${PEER1_RESEARCH} \
docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

echo "Installing chaincode for peer2.research ..."

${PEER2_RESEARCH} \
docker exec -it cli peer chaincode install -n ${CONTRACT_NAME} -v 1.0 -l node -p ${CONTRACT_PATH}

#---------- Instatiate chaincode ------------------

echo "Instatiate chaincode ..."

docker exec -it cli peer chaincode instantiate -o ordererhp.healthcare.com:7050 -C ${CHANNEL_NAME} -l node -n ${CONTRACT_NAME} -v 1.0 -c '{"Args":[]}'

${PEER0_HPROVIDER}
