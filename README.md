# infra

Kubernetes manifests, etc.

Commits to main go directly to production so be safe out there.
Or `make apply` to deploy locally.


## Network

TheLab has a handful of wifi access points, a router, and a switch.

The network is divided up into several subnets each on their own vlan.

- Members: 10.200.1.0/24
- Members Static IPs: 10.200.0.0/24
- Infrastructure: 10.200.10.0/24
- Cameras: 10.200.20.0/24
- Access Control: 10.220.4.0/24

Management points:

- 10.200.10.1: Mikrotik router web interface
- 10.200.10.2: Cisco network switch

### Switch VLAN Assignment

The switch has 4 obvious bays of ports, each assigned to a VLAN like:

- Cameras
- Members
- Infrastructure
- Access Control

## Servers

There are three Dell R710s below the network equipment rack.
Each has two NICs wired to the Cisco switch for bonded LACP links.
They're running vanilla Ubuntu 24 LTS with 6 disk RAID 10 arrays and LACP interfaces configured by the installer.
The only BIOS settings that are non-default: power recovery set to `on` in (weirdly) the System Security menu, with the startup delay set to `random` (to avoid flipping a breaker if they all fire up at once).

There is a bin of spare disks on the shelves somewhere in case any of the active ones go pop.

The three machines are named `foo`, `bar`, and `baz` and addressed 10.200.10.101, 10.200.10.102, etc.

## TODO: node bootstrapping, etc.
