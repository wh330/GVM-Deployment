# Helm chart for Greenbone Vulnerability Management (GVM)
## Helm installation
To install helm, follow the instructions in https://helm.sh/docs/intro/install/.

The helm version used for this deployment:
```bash
$ helm version
version.BuildInfo{Version:"v3.3.4", GitCommit:"a61ce5633af99708171414353ed49547cf05013d", GitTreeState:"clean", GoVersion:"go1.14.9"}
```

## Building chart from source
To build the gvm helm chart from source:

```bash
cd chart
helm package gvm
```
This should leave you with a `gvm-*.tgz` file ready to be deployed in k8s cluster.

## Installing GVM via helm chart
A running Postgres database is required for the GVMd component. To deploy one for testing you can run the k8s deployment in [./postgres](./postgres). Note that a persistent volume claim should already be created, you can use the specification in [./volumes](./volumes).
```bash
cd chart/gvm
kubectl apply -f postgres
```

Install the chart:

```bash
helm install gvm ./gvm-*.tgz --namespace gvm --set postgres.password="password" --set gmpClient.password="password"
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

## To-do
- Update [Configuration](#configuration).
- Create Cronjobs for the jobs in [./jobs](./jobs).
- Add GMP client deployment.
