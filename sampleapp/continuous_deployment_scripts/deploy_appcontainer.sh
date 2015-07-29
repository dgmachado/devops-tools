#!/bin/bash

if [ -z "${1}" ]; then
   version="latest"
   marathon="marathon"
else
   version="${1}"
   marathon=${MARATHON_PORT_8080_TCP_ADDR}
fi

curl -X DELETE -H "Content-Type: application/json" http://${marathon}:8080/v2/apps/app 
sleep 1
#curl -X POST -H "Content-Type: application/json" http://localhost:8080/v2/apps -d@app_marathon.json

cd continuous_deployment_scripts

cp -f marathon.json marathon.json.tmp
sed -i "s/latest/${version}/g" marathon.json.tmp


curl -X POST -H "Content-Type: application/json" http://${marathon}:8080/v2/apps -d@marathon.json.tmp

cd..