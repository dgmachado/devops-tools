#!/bin/bash

if [ -z "${1}" ]; then
   version="latest"
else
   version="${1}"
fi


docker push localhost:5000/sampleapp/nodejs_app:"${version}"
