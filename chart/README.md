# Helm chart for Greenbone Vulnerability Management (GVM)
## Introduction
You can use the provided helm chart in this repository to deploy Greenbone Source Edition (GSE) on your kubernetes cloud.

## Getting Helm
To use `helm` you have to first install it! For more information about installing helm follow the instructions at [helm installation notes](https://github.com/helm/helm#install).

## Building chart from source
Use the following instructions to build the gvm helm chart from source:

```bash
cd gvm-deployment/chart

helm dependency build gvm
helm package gvm
```

This should leave you with a `gvm-*.tgz` file ready to be deployed in the k8s.

## Installing GVM via helm chart
GVM uses several components and databases that should be deployed on k8s. Therefore, to have better control on you installation it isrecommended to crate a separate namespace for it:

```bash
kubectl create namespace gvm
```

Then you can install the chart with helm:

```bash
helm install ./gvm-*.tgz --namespace gvm --set gvmd-db.postgresqlPassword="mypassword"
```

## Configuration
The following table lists some of the useful configurable parameters of the GVM chart and their default values. For a complete list see [values.yaml](./gvm/values.yaml) file.

| Parameter                                 | Description                                                  | Default |
|-------------------------------------------|--------------------------------------------------------------|---------|
| image.gvmd.tag                            | the docker tag for gvmd image                                | 10      |
| image.gsad.tag                            | the docker tag for gsad image                                | 10      |
| image.openvas.tag                       | the docker tag for openvas image                           | 10      |
| gvmd-db.image.tag                         | the docker tag for gvm-postgres image                        | 10      |
| syncNvtPluginsAfterInstall                | run a nvt-sync job on post-installation                      | true    |
| syncScapCertDataAfterInstall              | run scapdata-sync and certdata-sync on post-installation     | false   |
| persistence.existingClaim                 | name of an existing pvc for data (nvt/scap/cert) persistence | ""      |
| gvmd-db.postgresqlPassword                | the password for "gvmduser" in "gvmd" postgresql database    | ""      |
| gvmd-db.persistence.existingClaim         | name of an existing pvc for postgresql data persistence      | ""      |
| openvas-redis.persistence.existingClaim | name of an existing pvc for redis data persistence           | ""      |
