
Drop this systemd unit in place to generate wireguard keys/configs.

```
# /usr/lib/systemd/system/wireguard.service

[Unit]
Description=Wireguard
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=podman run -it --rm --privileged --net=host -v /opt/wireguard:/config -e PEERS=thelabrouter,jordan,doug -e PUID=1000 -e PGID=100 -e TZ=Etc/UTC -e LOG_CONFS=false -e PERSISTENTKEEPALIVE_PEERS=thelabrouter -e SERVER_ALLOWEDIPS_PEER_thelabrouter=10.200.0.0/16 -e ALLOWEDIPS=10.13.13.0/24 docker.io/linuxserver/wireguard:1.0.20210914
LimitAS=infinity
LimitRSS=infinity
LimitCORE=infinity
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

This unit configures iptables on boot.

```
# /usr/lib/systemd/system/configure-iptables.service

[Unit]
Description=TheLab's iptables configuration applicator
After=network.target

[Service]
Type=oneshot
ExecStart=/opt/configure-iptables.sh

[Install]
WantedBy=multi-user.target
```

This is the script used by the above systemd unit.

```
# /opt/configure-iptables.sh

#!/bin/bash

set -e

echo 1 > /proc/sys/net/ipv4/ip_forward

rules=(
    'POSTROUTING -j MASQUERADE'
    'POSTROUTING -o eth0 -j SNAT --to-source 10.200.10.123'
    'PREROUTING -i eth0 -p tcp -m tcp --dport 80 -j DNAT --to-destination 10.200.10.123:80'
    'PREROUTING -i eth0 -p tcp -m tcp --dport 443 -j DNAT --to-destination 10.200.10.123:443'
    'PREROUTING -i eth0 -p tcp -m tcp --dport 6443 -j DNAT --to-destination 10.200.10.123:6443'
)

for t in "${rules[@]}"; do
    if iptables -t nat -C ${t} &> /dev/null; then
        echo "rule '${t}' already exists"
    else
        iptables -t nat -A ${t} > /dev/null
        echo "created rule '${t}'"
    fi
done
```
