#!/bin/bash

export IMAGE_TAG=1.4

./clean_up.sh

docker-compose -f compose-files/docker-compose.yaml up -d


