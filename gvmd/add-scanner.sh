#!/usr/bin/env bash
set -Eeuo pipefail

read -p "Scanner Name: " SCANNER_NAME
read -p "Scanner Host: " SCANNER_HOST

read -p "Scanner Port [9390]: " SCANNER_PORT
SCANNER_PORT=${SCANNER_PORT:-9390}

read -p "Scanner Type [OpenVAS]: " SCANNER_TYPE
SCANNER_TYPE=${SCANNER_TYPE:-OpenVAS}

read -p "Scanner CA certificate [/usr/var/lib/gvm/cacert.pem]: " SCANNER_CA_PUB
SCANNER_CA_PUB=${SCANNER_CA_PUB:-/usr/var/lib/gvm/cacert.pem}

read -p "Scanner public key [/usr/var/lib/gvm/cert.pem]: " SCANNER_KEY_PUB
SCANNER_KEY_PUB=${SCANNER_KEY_PUB:-/usr/var/lib/gvm/cert.pem}

read -p "Scanner private key [/usr/var/lib/gvm/key.pem]: " SCANNER_KEY_PRIVE
SCANNER_KEY_PRIVE=${SCANNER_KEY_PRIVE:-/usr/var/lib/gvm/key.pem}

echo "Adding scanner $SCANNER_NAME..."

gvmd --create-scanner=$SCANNER_NAME --scanner-host=$SCANNER_HOST --scanner-port=$SCANNER_PORT \
     --scanner-type=$SCANNER_TYPE --scanner-ca-pub=$SCANNER_CA_PUB \
     --scanner-key-pub=$SCANNER_KEY_PUB --scanner-key-priv=$SCANNER_KEY_PRIVE

# su -c "gvmd --create-scanner='$SCANNER_NAME' --scanner-type=OpenVAS --scanner-host='/sockets/$SCANNER_ID.sock'" gvm

# echo "$SCANNER_KEY\n" >> /data/scanner-ssh-keys/authorized_keys
# chown gvm:gvm -R /data/scanner-ssh-keys
