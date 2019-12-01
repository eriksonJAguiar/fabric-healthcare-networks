#!/bin/bash

export HPROVIDER_HOSTNAME = $(hostname)

docker-compose -f ./compose-files/docker-compose-pc2.yml up -d

