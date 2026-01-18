# Infra

This repo contains documentation and scripts related to TheLab Makerspace's IT infrastructure.


## Usage

> Make sure you have [conway](https://github.com/TheLab-ms/conway) cloned alongside this repo before running any make targets!

- `make foobar`: run Ansible against foobar.thelab.ms (cloud server)
- `make labpi`: run Ansible against labpi.thelab.ms (onprem server)


## Cloudflare

We use Cloudflare for various things including (most importantly) DNS. The account is associated with cto@thelab.ms, so new CTOs should go reset the password to get access. Things don't change often in this account but it's worth knowing that it exists.

Cloudflare tunnels are used for all ingress to our servers - no need to worry about rotating TLS certs, free DDoS protection, etc.


## Monitoring

We have a shared cronitor account used for uptime checks.
Failing checks are posted to #it and visible publicly at https://status.thelab.ms


## Network

### Hardware

- Router: `MikroTik RB5009UPr+S+` (10.200.10.1)
- Switch: `Aruba S2500-48P` (10.200.10.2)
- APs: `MikroTik RBcAPGi-5acD2nD` (x3)

Plus an RPI 5 for Frigate, etc. (labpi.thelab.ms)

### Subnets

- Members: 10.200.1.0/24
- IoT      10.200.2.0/24
- Admin:   10.200.10.0/24
- VPN:     10.13.13.2/24

### Port Assignments

Switch:

- 01-11: IoT VLAN
- 42-43: LACP router trunk
- 44-47: Admin VLAN
- else:  Members VLAN

Router:

- 1: uplink
- 2: unused (members vlan)
- 3-4: LACP router trunk
- 5: labpi
- 6: Rack AP
- 7: Entry AP
- 8: unused (admin vlan)

### Firewall Rules

- IoT can't route out to the internet
- IoT can reach Conway through the VPN without auth
- No other subnets can reach the Conway loopback
- Only the admin subnet can route to the iot subnet

