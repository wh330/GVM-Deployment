# GVM Helm chart
## Building chart from source
To build the gvm helm chart from source:

```bash
cd chart
helm package gvm
```
This should leave you with a `gvm-*.tgz` file ready to be deployed in k8s cluster.

## Installing the helm chart
There are manual steps required with the helm chart deployment:

1. Create the GVM namespace. This will hold the GVM namespaced resources such as
GVMd `Deployment` and remote scanner `Statefulset`.
```bash
kubectl create namespace gvm
```

2. Create self-signed TLS certificates for the GSAD service endpoint and update
[gvm/values](./gvm/values.yaml).

```bash
KEY_FILE=/tmp/host-example.key
CERT_FILE=/tmp/host-example.cert
HOST=host-example
CERT_NAME=host-example-tls
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $KEY_FILE -out $CERT_FILE -subj "/CN=$HOST/O=$HOST"
kubectl create secret tls $CERT_NAME --key $KEY_FILE --cert $CERT_FILE -n gvm
```

3.  Create the k8s Persistent Volume (PV) and Persistent Volume Claims (PVC). These will
store GVM config files, NVT, SCAP and Cert data. The dev and production PV and PVC spec
is defined in [volumes](./volumes).

```bash
kubectl apply -f volumes/dev-pvs.yaml
```

4.  Install `nfs-common` on k8s workers if not installed. This is needed for mounting the PV.
You can do that manually or with
[ansible ad-hoc](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html)
commands as follows.
```bash
ansible workers -m apt -a "name=nfs-common state=present" -i hosts -u your_user -become
```

5. Now you're ready to deploy the helm chart. Note that the username must be `gvmduser`
as it is unfortunately hard-coded in `dbconfig` scripts.

```bash
helm install gvm ./gvm-*.tgz --set postgres.host=host --set postgres.username=gvmduser --set postgres.password=password
```

6. Manually generate certificates for remote.
```bash
kubectl apply -f jobs/gen-certs.yaml
```

7. To run NVT and SCAP/Cert sync manually, make jobs out of the created cronjobs above:
```bash
kubectl create job -n gvm --from=cronjob/gvm-nvt-sync gvm-nvt-sync-manual
```
After the NVT sync job completed, run
```bash
kubectl create job -n gvm --from=cronjob/gvm-scap-cert-data-sync gvm-scap-cert-data-sync-manual
```

## Configuration
The following table lists some of the useful configurable parameters of the GVM chart and their default values. For a complete list see [values.yaml](./gvm/values.yaml) file.

| Parameter                                 | Description                                                  | Default |
|-------------------------------------------|--------------------------------------------------------------|---------|
| image.gvmd.tag                            | the docker tag for gvmd image                                | 10      |
| image.gsad.tag                            | the docker tag for gsad image                                | 10      |
| image.openvas.tag                         | the docker tag for openvas image                             | 10      |
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
