#!/bin/bash

docker rm -f $(docker ps -a -q)

docker volume prune

docker network prune

