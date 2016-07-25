#!/bin/bash

LCS_REPO=https://github.com/CBIIT/nci-webtools-dceg-risk-assessment
LCS_NAME=lungCancerScreening
LCS_PORT=8150

echo "This script will generate a \"deploy\" folder in the current working directory that contains the required scripts to start and stop this application using mod_wsgi."

mkdir -p deploy/app deploy/logs deploy/wsgi && cd deploy

rm -rf /tmp/lcs_tmp
git clone $LCS_REPO /tmp/lcs_tmp
cp -r /tmp/lcs_tmp/lungCancerScreening/* app/*

mod_wsgi-express setup-server app/$LCS_NAME.wsgi \
--port 8150 \
--user apache \
--group apache \
--server-root wsgi \
--document-root app \
--working-directory app \
--directory-index index.html \
--log-directory logs \
--rotate-logs

echo "wsgi/apachctl start" > start-$LCS_NAME.sh
echo "wsgi/apachctl stop" > stop-$LCS_NAME.sh

echo "Finished generating scripts. It is only necessary to start the application server once - the server will automatically restart upon detecting any changes in the python application files."
