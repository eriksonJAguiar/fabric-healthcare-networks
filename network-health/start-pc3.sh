#!/bin/bash

export RESEARCH_HOSTNAME = $(hostname)
export PATIENT_HOSTNAME = $(hostname)

docker-compose -f ./compose-files/docker-compose-pc3.yml up -d

