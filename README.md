# GVM deployment

## Introduction
This project contains the tools to deploy Greenbone Vulnerability
Management with containers. It is based on the [Greenbone Source Edition (GSE)](https://community.greenbone.net/c/gse) open source project.

## Docker
The source code of the docker images for Greenbone
Vulnerability Management 11 is based on [admirito's GVM PPA](https://launchpad.net/~mrazavi/+archive/ubuntu/gvm).

- Greenbone Vulnerability Manager
- OpenVAS remote network security scanner
- Greenbone Security Assistant
- PostgreSQL 12 Dataabase with `libgvm-pg-server` extension to be used by gvmd

The `docker-compose.yml` file also uses a [GMP client docker image](https://gitlab.developers.cam.ac.uk/wh330/gmp-client) to access the GVM container through GMP protocol.

To run the GVM containers with `docker-compose`:
```bash
cd gvm-deployment

docker-compose -f docker-compose.yml up
```
To run the GVM containers and enable NVT/CERT/SCAP data sync:
```bash
cd gvm-deployment

docker-compose -f docker-compose.yml -f nvt-sync.yml -f cert-sync.yml -f scap-sync.yml up
```

The Greenbone Security Assistant `gsad` port is exposed on the host's port 8080. So you can access it from http://localhost:8080.

## Helm Chart
A helm chart for deploying the docker images on kubernetes is also available. For more information please read the [chart/README](./chart/README.md).

## Resources
- https://github.com/admirito/gvm-containers
