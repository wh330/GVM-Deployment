#!/bin/bash

apt-get update

{ cat <<EOF
gcc
g++
make
bison
flex
libksba-dev
curl
libpcap-dev
cmake
git
pkg-config
libglib2.0-dev
libgpgme-dev
nmap
libgnutls28-dev
uuid-dev
libssh-gcrypt-dev
libldap2-dev
gnutls-bin
libmicrohttpd-dev
libhiredis-dev
zlib1g-dev
libxml2-dev
libradcli-dev
clang-format
libldap2-dev
doxygen
gcc-mingw-w64
xml-twig-tools
libical-dev
perl-base
heimdal-dev
libpopt-dev
libsnmp-dev
python3-setuptools
python3-paramiko
python3-lxml
python3-defusedxml
python3-dev
gettext
python3-polib
xmltoman
python3-pip
texlive-fonts-recommended
texlive-latex-extra
xsltproc
rsync
sudo
EOF
} | xargs apt-get install -yq --no-install-recommends

rm -rf /var/lib/apt/lists/*
