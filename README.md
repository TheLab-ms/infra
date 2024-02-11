# infra

Kubernetes manifests, etc.

Commits to main go directly to production so be safe out there.
Or `make apply` to deploy locally.


## Bootstrapping

There are a few steps that don't make sense to automate since they (hopefully) won't need to happen again.

```bash
kubectl create secret generic keycloak-admin --from-literal=KEYCLOAK_ADMIN_PASSWORD=$(openssl rand -base64 16)
kubectl create secret generic profile-file-token-key --from-literal=key=$(openssl rand -base64 32)
kubectl create secret generic reporting-psql --from-literal=password=$(openssl rand -base64 24)
kubectl create secret generic wikijs --from-literal=password=$(openssl rand -base64 24)

# Also create a Keycloak client called "k8s-csi-driver" to be used by the CSI driver: kubectl create secret generic keycloak-csi-driver-creds --from-literal=password=$CLIENT_SECRET
```
