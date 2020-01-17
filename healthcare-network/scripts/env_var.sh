export COMPOSE_PROJECT_NAME=net
export IMAGE_TAG=1.4
export CORE_PEER_TLS_ENABLED=true
export CA_TLS_ENABLED=true

# ----------------------
# for keepings same utils file when using multiple host
# 1 = Instantiating chaincode host
INSTANTIATING_HOST=true
COMPOSE_FILE=docker-compose-cli.yaml
#COMPOSE_FILE_RAFT=docker-compose-etcdraft2.yaml

LANGUAGE=javascript
VERSION=1.0.0
GO_PATH=/opt/gopath/src/
CHAINECODE_PATH="${GO_PATH}github.com/chaincode/" # defined in volume

CHANNEL_NAME=healthcarechannel

CHAINCODE_NAME=('healthcare')
CHAINCODE_NAME_WITH_PRIVATE_COLLECTION=()
CHAINCODE_POLICY=('"AND ('"'"'HP1MSP.peer'"'"','"'"'HP2MSP.peer'"'"')"')
CHAINCODE_POLICY_PRIVATE_COLLECTION=()

export DOMAIN=healthcare.com
export ORGANIZATION_NAME=(HP1MSP HP2MSP)
export ORGANIZATION_MSPID=(HP1MSP HP2MSP)
export ORGANIZATION_DOMAIN=(hp1.healthcare.com hp2.healthcare.com)
# dont forget to modify template count in crypto-config
ORGANIZATION_PEER_NUMBER=(1 1)
ORGANIZATION_PEER_STARTING_PORT=(7051 9051) # PORT START NUMBER

ORDERER_TYPE="kafka"
ORDERER_NAME="ordererhp"
ORDERER_DOMAIN="ordererhp.healthcare.com"
ORDERER_CA_PATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/healthcare.com/orderers/${ORDERER_DOMAIN}/msp/tlscacerts/tlsca.healthcare.com-cert.pem"
