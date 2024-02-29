# infra

Kubernetes manifests, etc.

Commits to main go directly to production so be safe out there.
Or `make apply` to deploy locally.


## Provisioning

- Imaged with a flash drive + ubuntu-23.04-live-server-amd64.iso (23ed9d0689ee04b4dafbc575523fb8a5)
  - I couldn't login to the IPMI, kicked it old school with a monitor and keyboard instead
- Logged in with temporary password set during installation, disabled ssh login with passwords, added own ssh key
- Configured static IP
- Enabled passwordless sudo


## Kubernetes Bootstrapping

Install k3s with these flags:

- --disable-traefik

After installing k3s there are a few steps that don't make sense to automate since they (hopefully) won't need to happen again.

```bash
kubectl create secret generic oauth-cookie-secret --from-literal=secret=$(openssl rand -base64 24)
kubectl create secret generic keycloak-admin --from-literal=KEYCLOAK_ADMIN_PASSWORD=$(openssl rand -base64 16)
kubectl create secret generic profile-file-token-key --from-literal=key=$(openssl rand -base64 32)
kubectl create secret generic reporting-psql --from-literal=password=$(openssl rand -base64 24)
kubectl create secret generic wikijs --from-literal=password=$(openssl rand -base64 24)
kubectl create secret generic keycloak-db --from-literal=password=$(openssl rand -base64 24)

# Also create a Keycloak client called "k8s-csi-driver" to be used by the CSI driver: kubectl create secret generic keycloak-csi-driver-creds --from-literal=password=$CLIENT_SECRET

# Get a service principal to access Azure like: kubectl create secret generic azure-sp --from-literal=clientID=846d6a2c-6fa0-48f5-b810-f997cf8d8e50 --from-literal=secret=SECRET
```
