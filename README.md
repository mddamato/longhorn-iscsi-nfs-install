# longhorn-iscsi-nfs-install

Daemonset to test method for RPM repo distribution for offline installations. Be careful with this as the permissions currently configured for the container is quite insecure.

Another idea could be a similar approach but instead of copying the RPMs to the host, serve them up on an nginx server and expost a nodePort for all hosts to temporarily use for an installation and then switch to pause.

Drops in a local rpm repo, does the installation, then cleans up. Makes shipping and distributing repos across nodes offline a little easier.

Build image:

```bash
docker build -t docker.io/mddamato/longhorn-iscsi-nfs-utils:v0 .

docker push docker.io/mddamato/longhorn-iscsi-nfs-utils:v0
```