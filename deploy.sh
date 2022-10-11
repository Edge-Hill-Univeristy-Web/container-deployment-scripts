#!/bin/bash
##################################################################
# This script will deploy the EHU CIS docker containers 

# Flags
#       -h = Help
#       -m = Module Code

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
        y) year=22;;
        \?) # incorrect option
         echo "Error: Invalid option"
         exit;
    esac
done

year=22

# Checks for values!
if [ -z "$year" ] ; then
    echo "[ERROR] please specify a value for YEAR using the -y flag"
fi

if [ -z "$modulecode" ] ; then
    echo "[ERROR] please specify a value for MODULECODE using the -m flag"
fi

if [ -z "$modulecode" ] || [ -z "$year" ] ; then
    exit;
fi

echo "[INFO] Beginning Deployment of "$modulecode""

FILE="EHU-CIS-Docker/docker-compose.yml"

# Check if docker-compose.yml exists
if [ -f "$FILE" ]; then
    echo "[INFO] $FILE exists. Proceeding to deploy"
else 
    echo "[INFO] $FILE does not exist. Proceeding to download..."
    git clone https://github.com/Edge-Hill-Univeristy-Web/EHU-CIS-Docker.git
fi

cd EHU-CIS-Docker

if [ -f ".env" ] ; then
    echo "[INFO] .env file already exists. Proceeding to remove"
    rm .env
fi

# Creates .env based on flags
cat <<EOT >> .env
MODULE_CODE="$modulecode"
YEAR="$year"
EOT

echo "[INFO] Created environment variables"
echo "[INFO] Deploying CIS$modulecode Container"
echo

docker-compose up -d
