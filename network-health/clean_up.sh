#!/bin/bash

docker rm -f $(docker ps -a -q)

docker volume -f prune

docker network -f prune

