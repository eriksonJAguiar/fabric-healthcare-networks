#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error, print all commands.
set -ev

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

docker-compose -f docker-compose-cli.yaml down

docker-compose -f docker-compose-cli.yaml up -d ca.hp1.healthcare.com ca.hp2.healthcare.com ordererhp.healthcare.com peer0.hp1.healthcare.com couchdb

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=hp1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@hp1.healthcare.com/msp" peer0.hp1.healthcare.com peer channel create -o ordererhp.healthcare.com:7050 -c HealthcareChannel -f /etc/hyperledger/configtx/channel.tx
# Join peer0.hp1.healthcare.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=hp1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@hp1.healthcare.com/msp" peer0.hp1.healthcare.com peer channel join -b healthcareChannel.block
