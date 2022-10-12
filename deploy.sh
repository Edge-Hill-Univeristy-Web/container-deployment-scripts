#!/bin/bash
##################################################################
# This script will deploy the EHU CIS docker containers 

# Flags
#       -h = Displays Help
#       -m = This will build & deploy or deploy a container if exists for the module specified.

# Author : Dan Campbell
##################################################################
while getopts hm: flag
do
    case "${flag}" in
        h)  echo "deploy-cis-containers."
            echo "Usage    :    ./deploy-cis-container.sh -m <modulecode>"
            echo "Example  :    ./deploy-cis-container.sh -m 2152"
            echo
            echo "Syntax   :  [-h|m]"
            echo "options  :"
            echo
            echo "-h     prints help"
            echo
            echo "The following flags are required for the script to function"
            echo "-m     Module code [example 2152]"
            exit;;
        m) modulecode=${OPTARG};;
        \?) # incorrect option
         echo "[Error] Invalid option"
         exit;
    esac
done

year=22

if [ -z "$modulecode" ] ; then
    echo "[ERROR] please specify a value for MODULECODE using the -m flag"
fi

if [ -z "$modulecode" ] || [ -z "$year" ] ; then
    exit;
fi

echo "[INFO] Starting EHU CIS Container Deployment...."

FILE="./CIS${modulecode}/docker-compose.yml"

# Check if docker-compose.yml exists
if [ -f "$FILE" ]; then
    echo "[INFO] A docker-compose file exists for CIS${modulecode}. Proceeding to deploy..."
    cd ./CIS${modulecode}
    docker container start CIS${modulecode}
   
    DOCKER_OUTPUT="$(docker container start CIS${modulecode} 2>&1 > /dev/null)"
   
    if [[ $DOCKER_OUTPUT == *"No such container: CIS${modulecode}"* ]]; then
        echo "[INFO] A Container for CIS${modulecode} does not exist on the system. Attempting to Deploying"
        docker-compose up -d
    fi
    exit;
else 
    echo "[INFO] A docker-compose file does not exists for CIS${modulecode}. Proceeding to create..."
    mkdir ./CIS${modulecode}
    cd ./CIS${modulecode}
    cat <<EOF >> .env
COMPOSE_PROJECT_NAME=EHU_CIS_Containers
EOF

    cat <<EOF >> docker-compose.yml
version: '3.9'
services:
    ehu-cis${modulecode}-container:
        container_name: CIS${modulecode}
        ports:
            - '${modulecode}:8888'
        volumes:
            - ./CIS${modulecode}:/home/ehu/CIS${modulecode}-${YEAR}
        image: walshd/ehucis${modulecode}
EOF
    echo "[INFO] Building and Deploying CIS$modulecode Container"
    docker-compose up -d
fi