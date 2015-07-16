#!/bin/bash

if [ -z "${1}" ]; then
   version="latest"
else
   version="${1}"
fi


cd nodejs_app
docker build -t localhost:5000/sampleapp/nodejs_app:${version} .
cd ..
