#!/bin/bash

export RESEARCH_HOSTNAME=$(hostname)
export HPROVIDER_HOSTNAME=$(hostname)
export ORDERER_HOSTNAME=$(hostname)

docker network create -d overlay --attachable healthNetwork

docker-compose -f ./compose-files/docker-compose-orderer.yml up -d

docker-compose -f ./compose-files/docker-compose-pc1.yml up -d
