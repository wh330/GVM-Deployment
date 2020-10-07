#!/bin/bash

set -e

export OV_MAX_HOST=${OV_MAX_HOST:-5}
export OV_MAX_CHECKS=${OV_MAX_CHECKS:-4}

mkdir -p /etc/openvas/

cat >/etc/openvas/openvas.conf<<-EOF
max_hosts = ${OV_MAX_HOST}
max_checks = ${OV_MAX_CHECKS}
EOF

if [ "${1:0:1}" = '-' ]; then
    set -- ospd-openvas "$@"
fi

if [ "$1" = 'ospd-openvas' ]; then
    chmod -R 777 /var/run/redis/

    rm -f /var/run/ospd.pid
    mkdir -p /var/run/ospd

    if [ -z "${SKIP_WAIT_REDIS}" ]; then
	echo "waiting for the redis..."
	while [ ! -e /var/run/redis/redis.sock ]; do
	    sleep 1;
	done
    fi
fi

# Make sure certs for ospd-openvas exist
if [ ! -f "/usr/var/lib/gvm/private/CA/serverkey.pem" ] ||
    [ ! -f "/usr/var/lib/gvm/CA/servercert.pem" ] ||
    [ ! -f "/usr/var/lib/gvm/CA/cacert.pem" ]; then
    echo "Certs don't exist. Exit"
    exit 1
fi

exec "$@"
