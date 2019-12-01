#!/bin/bash

export PATIENT_HOSTNAME = $(hostname)

docker-compose -f ./compose-files/docker-compose-pc4.yml up -d

