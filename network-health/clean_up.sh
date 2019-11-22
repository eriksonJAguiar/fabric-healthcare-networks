#!/bin/bash

# orderer
docker-compose -f docker-compose-orderer.yml down
# node1
docker-compose -f docker-compose-node1.yml down
docker rm $(docker ps -aq)
docker rmi $(docker images net-* -q)
# node2
docker-compose -f docker-compose-node2.yml down
docker rm $(docker ps -aq)
docker rmi $(docker images net-* -q)
# node3
docker-compose -f docker-compose-node3.yml down
docker rm $(docker ps -aq)
docker rmi $(docker images net-* -q)