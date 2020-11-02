#!/usr/bin/env bash

# A variation of add-scanner.sh. It only takes the hostname of the scanner as an argument.
# Scanner name will the same as the scanner hostname and the other attributes will get
# the default values as stated below.

if [ $# -eq 0 ]
then
    echo "Scanner hostname argument is missing."
    exit
fi

SCANNER_NAME=$1
SCANNER_HOST=$1
SCANNER_PORT=9391
SCANNER_TYPE=OpenVAS
SCANNER_CA_PUB=/usr/var/lib/gvm/cacert.pem
SCANNER_KEY_PUB=/usr/var/lib/gvm/cert.pem
SCANNER_KEY_PRIVE=/usr/var/lib/gvm/key.pem

echo "Adding scanner $SCANNER_NAME..."

gvmd --create-scanner=$SCANNER_NAME --scanner-host=$SCANNER_HOST --scanner-port=$SCANNER_PORT \
     --scanner-type=$SCANNER_TYPE --scanner-ca-pub=$SCANNER_CA_PUB \
     --scanner-key-pub=$SCANNER_KEY_PUB --scanner-key-priv=$SCANNER_KEY_PRIVE
