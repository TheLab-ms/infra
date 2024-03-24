# infra

Kubernetes manifests, etc.

Commits to main go directly to production so be safe out there.
Or `make apply` to deploy locally.


## Network

TheLab has three wifi access points, a router, and a switch.

The network is divided up into several subnets each on their own vlan.

- Members: 10.200.1.0/24
- Members Static IPs: 10.200.0.0/24
- Infrastructure: 10.200.10.0/24
- Cameras: 10.200.20.0/24
- Access Control: 10.220.4.0/24

### Important Debugging Info

- 10.200.10.1: Mikrotik router web interface
- 10.200.10.2: Cisco network switch

Port 48 of the switch is in the infrastructure VLAN - use that to debug if APs are down.

### Switch VLAN Assignment

The switch has 4 obvious bays of ports, each assigned to a VLAN like:

- Cameras
- Members
- Members
- Access Control
- (port 48 only) Infrastructure

## Bootstrapping

## Server Provisioning

- Imaged with a flash drive + ubuntu-23.04-live-server-amd64.iso (23ed9d0689ee04b4dafbc575523fb8a5)
  - I couldn't login to the IPMI, kicked it old school with a monitor and keyboard instead
- Logged in with temporary password set during installation, disabled ssh login with passwords, added own ssh key
- Configured static IP
- Enabled passwordless sudo

## Kubernetes

Install k3s with these flags:

- --disable=traefik
- --disable=servicelb

After installing k3s there are a few steps that don't make sense to automate since they (hopefully) won't need to happen again.

```bash
kubectl create secret generic oauth-cookie-secret --from-literal=secret=$(openssl rand -base64 24)
kubectl create secret generic keycloak-admin --from-literal=KEYCLOAK_ADMIN_PASSWORD=$(openssl rand -base64 16)
kubectl create secret generic reporting-psql --from-literal=password=$(openssl rand -base64 24)
kubectl create secret generic wikijs --from-literal=password=$(openssl rand -base64 24)
kubectl create secret generic keycloak-db --from-literal=password=$(openssl rand -base64 24)

# Also create a Keycloak client called "k8s-csi-driver" to be used by the CSI driver: kubectl create secret generic keycloak-csi-driver-creds --from-literal=password=$CLIENT_SECRET

# Get a service principal to access Azure like: kubectl create secret generic azure-sp --from-literal=clientID=846d6a2c-6fa0-48f5-b810-f997cf8d8e50 --from-literal=secret=SECRET
```
