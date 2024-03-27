# 2024-03-26 22:07:16 by RouterOS 7.14
# software id = 83UA-A1D9
#
# model = RB5009UPr+S+
# serial number = HFA097CGESH
/caps-man channel
add band=5ghz-a/n/ac control-channel-width=20mhz frequency=5180 name=5ghz
add band=2ghz-g/n control-channel-width=20mhz extension-channel=Ce frequency=\
    2412 name=2ghz
/interface bridge
add admin-mac=78:9A:18:A2:DA:83 auto-mac=no name=bridge port-cost-mode=short \
    vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] advertise="10M-baseT-half,10M-baseT-full,100M\
    -baseT-half,100M-baseT-full,1G-baseT-half,1G-baseT-full" name=\
    ether1-internet
set [ find default-name=ether2 ] name=ether2-switch-trunk-a
set [ find default-name=ether3 ] name=ether3-switch-trunk-b
set [ find default-name=ether4 ] name=ether4-supermicro-1
set [ find default-name=ether5 ] name=ether5-supermicro-2
set [ find default-name=ether6 ] name=ether6-classroom-ap
set [ find default-name=ether7 ] name=ether7-front-door-ap
set [ find default-name=ether8 ] name=ether8-vent-room-ap
set [ find default-name=sfp-sfpplus1 ] disabled=yes
/interface wireguard
add listen-port=51820 mtu=1420 name=wg1
/interface vlan
add comment=10.200.1.1 interface=bridge name=vlan1-members vlan-id=201
add comment=10.200.10.1 interface=bridge name=vlan2-infra vlan-id=210
add comment=10.200.2.1 interface=bridge name=vlan3-cameras vlan-id=220
add comment=10.220.4.254 interface=bridge name=vlan4-access-controls vlan-id=\
    240
/interface bonding
add mode=802.3ad name=bonding1-switch-trunk slaves=\
    ether2-switch-trunk-a,ether3-switch-trunk-b
/caps-man datapath
add bridge=bridge local-forwarding=yes name=members vlan-id=201 vlan-mode=\
    use-tag
add bridge=bridge local-forwarding=yes name=cameras vlan-id=220 vlan-mode=\
    use-tag
/caps-man security
add authentication-types=wpa2-psk \
    encryption=aes-ccm,tkip name=members
add authentication-types=wpa2-psk encryption=aes-ccm,tkip \
    name=cameras
/caps-man configuration
add channel=2ghz country="united states3" datapath=members installation=any \
    multicast-helper=full name=members security=members ssid=\
    TheLab.ms-Members
add channel=2ghz country="united states3" datapath=cameras hide-ssid=yes \
    installation=any mode=ap name=thelab-cameras security=cameras ssid=\
    thelab-cameras
add channel=5ghz country="united states3" datapath=members installation=any \
    mode=ap multicast-helper=full name=members-5g security=members ssid=\
    TheLab.ms-Members5g
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=Members ranges=10.200.1.5-10.200.1.254
add name=Infra ranges=10.200.10.5-10.200.10.254
add name=Cameras ranges=10.200.2.5-10.200.2.254
/ip dhcp-server
add address-pool=Members interface=vlan1-members lease-time=10m name=Members
add address-pool=Infra interface=vlan2-infra lease-time=10m name=Infra
add address-pool=Cameras interface=vlan3-cameras lease-time=10m name=Cameras
/caps-man manager
set enabled=yes
/caps-man provisioning
add action=create-dynamic-enabled hw-supported-modes=g master-configuration=\
    members name-format=identity slave-configurations=thelab-cameras
add action=create-dynamic-enabled hw-supported-modes=ac master-configuration=\
    members-5g name-format=identity
/interface bridge port
add bridge=bridge interface=ether8-vent-room-ap internal-path-cost=10 \
    path-cost=10 pvid=210
add bridge=bridge interface=bonding1-switch-trunk pvid=201
add bridge=bridge interface=ether4-supermicro-1 pvid=210
add bridge=bridge interface=ether5-supermicro-2 pvid=210
add bridge=bridge interface=ether6-classroom-ap pvid=210
add bridge=bridge interface=ether7-front-door-ap pvid=210
add bridge=bridge interface=vlan1-members
add bridge=bridge interface=vlan2-infra
add bridge=bridge interface=vlan3-cameras
add bridge=bridge interface=vlan4-access-controls
/ip firewall connection tracking
set udp-timeout=10s
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface bridge vlan
add bridge=bridge comment="Cameras (10.200.2.0/24)" tagged="bridge,bonding1-sw\
    itch-trunk,ether8-vent-room-ap,ether7-front-door-ap,ether6-classroom-ap" \
    vlan-ids=220
add bridge=bridge comment="Infra (10.200.10.0/24)" tagged=\
    bridge,bonding1-switch-trunk vlan-ids=210
add bridge=bridge comment="Members (10.200.1.0/24)" tagged="bridge,ether8-vent\
    -room-ap,ether7-front-door-ap,ether6-classroom-ap,ether4-supermicro-1,bond\
    ing1-switch-trunk" vlan-ids=201
add bridge=bridge comment="Access Controls (10.220.4.0/24)" tagged=\
    bonding1-switch-trunk,bridge vlan-ids=240
/interface list member
add interface=ether1-internet list=WAN
/interface wifi capsman
set ca-certificate=auto certificate=auto interfaces=bridge package-path="" \
    require-peer-certificate=no upgrade-policy=suggest-same-version
/interface wireguard peers
add allowed-address=10.13.13.0/24 client-address=10.13.13.2/32 comment=Azure \
    endpoint-address=40.119.50.30 endpoint-port=51820 interface=wg1 \
    persistent-keepalive=20s preshared-key=\
    "ZlXncJeuACxI1y/8dguDw/tAwHg0bvlvuIvgUdYmDSQ=" public-key=\
    "ensRRimM3o5s1OfV2IGSfE0LJXA6OBD2UGh7cBApflg="
/ip address
add address=10.200.1.1/24 comment=Members interface=vlan1-members network=\
    10.200.1.0
add address=10.200.10.1/24 comment=Infra interface=vlan2-infra network=\
    10.200.10.0
add address=10.200.2.1/24 comment=Cameras interface=vlan3-cameras network=\
    10.200.2.0
add address=10.200.0.1/24 comment="Members Statics" interface=vlan1-members \
    network=10.200.0.0
add address=10.220.4.254/24 comment="Access Control" interface=\
    vlan4-access-controls network=10.220.4.0
add address=10.13.13.2/24 comment=wireguard interface=wg1 network=10.13.13.0
/ip cloud
set ddns-update-interval=12h
/ip dhcp-client
add interface=ether1-internet use-peer-dns=no use-peer-ntp=no
/ip dhcp-server lease
add address=10.200.0.32 client-id=1:b8:27:eb:9:11:2a comment=\
    prusa1.thelab.lan mac-address=B8:27:EB:09:11:2A server=Members
add address=10.200.0.80 client-id=1:18:48:ca:86:b2:48 comment=\
    "Dyesub wireless" mac-address=18:48:CA:86:B2:48 server=Members
add address=10.200.0.70 client-id=1:3c:77:e6:57:ce:ac comment=\
    "Brother 3170CDW on loan from DougEmes" mac-address=3C:77:E6:57:CE:AC \
    server=Members
add address=10.200.0.33 client-id=1:d8:3a:dd:5f:a2:27 comment="Sovol Pi4" \
    mac-address=D8:3A:DD:5F:A2:27 server=Members
add address=10.200.2.7 client-id=1:2c:aa:8e:13:bb:45 comment=Classroom2 \
    mac-address=2C:AA:8E:13:BB:45 server=Cameras
add address=10.200.2.8 client-id=1:2c:aa:8e:9:99:e0 comment=Cleanroom \
    mac-address=2C:AA:8E:09:99:E0 server=Cameras
add address=10.200.2.10 client-id=1:2c:aa:8e:eb:75:5f comment=\
    "Kitchen Camera" mac-address=2C:AA:8E:EB:75:5F server=Cameras
add address=10.200.2.12 client-id=1:a4:da:22:33:e5:80 comment=\
    "Atrium Door Camera" mac-address=A4:DA:22:33:E5:80 server=Cameras
add address=10.200.2.13 client-id=1:a0:60:32:2:18:18 comment="Atrium Camera" \
    mac-address=A0:60:32:02:18:18 server=Cameras
add address=10.200.2.14 client-id=1:c4:2f:90:df:41:ee comment=\
    "Old atrium cam" mac-address=C4:2F:90:DF:41:EE server=Cameras
add address=10.200.2.15 client-id=1:c4:2f:90:16:bb:7c comment=\
    "Old woodshop camera" mac-address=C4:2F:90:16:BB:7C server=Cameras
add address=10.200.2.16 client-id=1:c4:2f:90:16:bc:84 comment=Classroom1 \
    mac-address=C4:2F:90:16:BC:84 server=Cameras
add address=10.200.0.35 client-id=1:50:41:1c:89:d7:1a comment=\
    "Bambu X1C (PLA only)" mac-address=50:41:1C:89:D7:1A server=Members
add address=10.200.2.17 client-id=1:a0:60:32:2:1e:49 comment=\
    "Vent Room Camera" mac-address=A0:60:32:02:1E:49 server=Cameras
add address=10.200.0.34 client-id=1:b8:13:32:84:ca:f0 comment=\
    "Bambu X1C (Giga)" mac-address=B8:13:32:84:CA:F0 server=Members
add address=10.200.1.200 comment="XTOOL d1 Pro" mac-address=94:E6:86:92:78:EC \
    server=Members
add address=10.200.2.18 client-id=1:a0:60:32:1:6f:68 comment=\
    "Woodshop Camera" mac-address=A0:60:32:01:6F:68 server=Cameras
/ip dhcp-server network
add address=10.200.0.0/24 comment="Statics on Members VLAN" dns-server=\
    10.200.0.1 gateway=10.200.0.1 netmask=24 ntp-server=10.200.0.1
add address=10.200.1.0/24 comment=Members dns-server=10.200.1.1 gateway=\
    10.200.1.1 netmask=24 ntp-server=10.200.1.1
add address=10.200.2.0/24 comment=Cameras dns-server=10.200.2.1 gateway=\
    10.200.2.1 netmask=24 ntp-server=10.200.2.1
add address=10.200.10.0/24 caps-manager=10.200.10.1 comment=Infra dns-server=\
    10.200.10.1 gateway=10.200.10.1 netmask=24 ntp-server=10.200.10.1
/ip dns
set allow-remote-requests=yes servers=1.1.1.1,8.8.8.8,8.8.4.4
/ip dns static
add address=10.200.0.32 comment="3D printing" name=prusa1.thelab.lan
add address=10.200.10.123 name=supermicro1.thelab.lan
add address=10.200.10.124 name=supermicro2.thelab.lan
add address=10.200.1.10 comment="dyesub printer" name=dyesub.thelab.lan
add address=10.200.0.33 comment="SOVOL 3d Printing" name=\
    octopi_sovol.thelab.lan
add address=10.200.0.33 name=octopi.thelab.lan
/ip firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input comment=\
    "defconf: accept to local loopback (for CAPsMAN)" dst-address=127.0.0.1
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related hw-offload=yes
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf: drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
add action=drop chain=input comment="no touchy from internet" \
    in-interface-list=WAN
add action=drop chain=output comment="cameras no phone home" src-address=\
    10.200.2.0/24
add action=drop chain=forward comment="only infra vlan can reach cameras" \
    in-interface=!vlan2-infra out-interface=vlan3-cameras
/ip firewall nat
add action=masquerade chain=srcnat comment="internet nat" ipsec-policy=\
    out,none out-interface-list=WAN
add action=accept chain=srcnat comment=capsman ipsec-policy=out,none \
    out-interface=bridge
/ip traffic-flow
set interfaces=ether1-internet
/ipv6 firewall address-list
add address=::/128 comment="defconf: unspecified address" list=bad_ipv6
add address=::1/128 comment="defconf: lo" list=bad_ipv6
add address=fec0::/10 comment="defconf: site-local" list=bad_ipv6
add address=::ffff:0.0.0.0/96 comment="defconf: ipv4-mapped" list=bad_ipv6
add address=::/96 comment="defconf: ipv4 compat" list=bad_ipv6
add address=100::/64 comment="defconf: discard only " list=bad_ipv6
add address=2001:db8::/32 comment="defconf: documentation" list=bad_ipv6
add address=2001:10::/28 comment="defconf: ORCHID" list=bad_ipv6
add address=3ffe::/16 comment="defconf: 6bone" list=bad_ipv6
/ipv6 firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMPv6" protocol=\
    icmpv6
add action=accept chain=input comment="defconf: accept UDP traceroute" port=\
    33434-33534 protocol=udp
add action=accept chain=input comment=\
    "defconf: accept DHCPv6-Client prefix delegation." dst-port=546 protocol=\
    udp src-address=fe80::/10
add action=accept chain=input comment="defconf: accept IKE" dst-port=500,4500 \
    protocol=udp
add action=accept chain=input comment="defconf: accept ipsec AH" protocol=\
    ipsec-ah
add action=accept chain=input comment="defconf: accept ipsec ESP" protocol=\
    ipsec-esp
add action=accept chain=input comment=\
    "defconf: accept all that matches ipsec policy" ipsec-policy=in,ipsec
add action=drop chain=input comment=\
    "defconf: drop everything else not coming from LAN" in-interface-list=\
    !LAN
add action=accept chain=forward comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf: drop packets with bad src ipv6" src-address-list=bad_ipv6
add action=drop chain=forward comment=\
    "defconf: drop packets with bad dst ipv6" dst-address-list=bad_ipv6
add action=drop chain=forward comment="defconf: rfc4890 drop hop-limit=1" \
    hop-limit=equal:1 protocol=icmpv6
add action=accept chain=forward comment="defconf: accept ICMPv6" protocol=\
    icmpv6
add action=accept chain=forward comment="defconf: accept HIP" protocol=139
add action=accept chain=forward comment="defconf: accept IKE" dst-port=\
    500,4500 protocol=udp
add action=accept chain=forward comment="defconf: accept ipsec AH" protocol=\
    ipsec-ah
add action=accept chain=forward comment="defconf: accept ipsec ESP" protocol=\
    ipsec-esp
add action=accept chain=forward comment=\
    "defconf: accept all that matches ipsec policy" ipsec-policy=in,ipsec
add action=drop chain=forward comment=\
    "defconf: drop everything else not coming from LAN" in-interface-list=\
    !LAN
/system clock
set time-zone-name=America/Chicago
/system note
set show-at-login=no
/system ntp client
set enabled=yes
/system ntp server
set enabled=yes
/system ntp client servers
add address=0.pool.ntp.org
add address=1.pool.ntp.org
add address=2.pool.ntp.org
add address=3.pool.ntp.org
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
