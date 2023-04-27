default_DEV=$(ip route | awk '/default/ { print $5 }')

# bridge
br_DEV="br0"
br_nsA_INTERFACE="host-nsA"
br_nsB_INTERFACE="host-nsB"
br0_IP=10.33.55.1
br0_CIDR="${br0_IP}/24"

# nsA
nsA_NS="nsA"
nsA_DEV_UP="${nsA_NS}-eth0"
nsA_IP_UP=10.33.55.2
nsA_CIDR_UP="${nsA_IP_UP}/24"

nsA_DEV_DOWN="${nsA_NS}-eth1"
nsA_IP_DOWN=140.113.100.254
nsA_CIDR_DOWN="${nsA_IP_DOWN}/24"

# nsB
nsB_NS="nsB"
nsB_DEV="${nsB_NS}-eth0"
nsB_IP=10.33.55.3
nsB_CIDR="${nsB_IP}/24"

# nsNYCU
nsNYCU_NS="nsNYCU"
nsNYCU_DEV_UP="${nsNYCU_NS}-eth0"
nsNYCU_IP_UP=140.113.100.200
nsNYCU_CIDR_UP="${nsNYCU_IP_UP}/24"

nsNYCU_DEV_RIGHT="${nsNYCU_NS}-eth1"
nsNYCU_IP_RIGHT=140.114.100.254
nsNYCU_CIDR_RIGHT="${nsNYCU_IP_RIGHT}/24"

nsNYCU_DEV_LEFT="${nsNYCU_NS}-eth2"
nsNYCU_IP_LEFT=140.128.100.254
nsNYCU_CIDR_LEFT="${nsNYCU_IP_LEFT}/24"

# nsNTHU
nsNTHU_NS="nsNTHU"
nsNTHU_DEV="${nsNTHU_NS}-eth0"
nsNTHU_IP=140.114.100.200
nsNTHU_CIDR="${nsNTHU_IP}/24"

# nsTHU
nsTHU_NS="nsTHU"
nsTHU_DEV="${nsTHU_NS}-eth0"
nsTHU_IP=140.128.100.200
nsTHU_CIDR="${nsTHU_IP}/24"
ip netns add nsA
ip netns add nsB
ip netns add nsNYCU
ip netns add nsNTHU
ip netns add nsTHU
ip link add nsA-eth0    type veth peer name host-nsA
ip link add nsB-eth0    type veth peer name host-nsB
ip link add nsA-eth1    type veth peer name nsNYCU-eth0
ip link add nsNYCU-eth1 type veth peer name nsNTHU-eth0
ip link add nsNYCU-eth2 type veth peer name nsTHU-eth0
ip link set nsA-eth0    netns nsA
ip link set nsA-eth1    netns nsA
ip link set nsB-eth0    netns nsB
ip link set nsNYCU-eth0 netns nsNYCU
ip link set nsNYCU-eth1 netns nsNYCU
ip link set nsNYCU-eth2 netns nsNYCU
ip link set nsNTHU-eth0 netns nsNTHU
ip link set nsTHU-eth0  netns nsTHU
ip netns exec nsA    ip addr add 10.33.55.2/24      dev nsA-eth0 # dev: device
ip netns exec nsA    ip addr add 140.113.100.254/24 dev nsA-eth1
ip netns exec nsB    ip addr add 10.33.55.3/24      dev nsB-eth0
ip netns exec nsNYCU ip addr add 140.113.100.200/24 dev nsNYCU-eth0
ip netns exec nsNYCU ip addr add 140.114.100.254/24 dev nsNYCU-eth1
ip netns exec nsNYCU ip addr add 140.128.100.254/24 dev nsNYCU-eth2
ip netns exec nsNTHU ip addr add 140.114.100.200/24 dev nsNTHU-eth0
ip netns exec nsTHU  ip addr add 140.128.100.200/24 dev nsTHU-eth0
ip netns exec nsA    ip link set nsA-eth0 up
ip netns exec nsA    ip link set lo up # lo: loopback device
ip netns exec nsA    ip link set nsA-eth1 up
ip netns exec nsA    ip link set lo up # lo
ip netns exec nsB    ip link set nsB-eth0 up
ip netns exec nsB    ip link set lo up
ip netns exec nsNYCU ip link set nsNYCU-eth0 up
ip netns exec nsNYCU ip link set lo up
ip netns exec nsNYCU ip link set nsNYCU-eth1 up
ip netns exec nsNYCU ip link set lo up
ip netns exec nsNYCU ip link set nsNYCU-eth2 up
ip netns exec nsNYCU ip link set lo up
ip netns exec nsNTHU ip link set nsNTHU-eth0 up
ip netns exec nsNTHU ip link set lo up
ip netns exec nsTHU  ip link set nsTHU-eth0 up
ip netns exec nsTHU  ip link set lo up
ip link add name br0 type bridge
ip link set host-nsA master br0
ip link set host-nsB master br0
ip addr add 10.33.55.1/24 brd + dev br0 # brd: broadcast
ip link set host-nsA up
ip link set host-nsB up
ip link set br0 up
nsA_MAC=$(ip netns exec nsA ip link show nsA-eth0 | awk '/ether/ {print $2}')
nsB_MAC=$(ip netns exec nsB ip link show nsB-eth0 | awk '/ether/ {print $2}')
ip netns exec nsA    ip route add default via 10.33.55.1
ip netns exec nsB    ip route add default via 10.33.55.1
ip netns exec nsNYCU ip route add default via 140.113.100.254
ip netns exec nsNTHU ip route add default via 140.114.100.254
ip netns exec nsTHU  ip route add default via 140.128.100.254
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -o ens33 -i br0 -j ACCEPT # ens33 depend on Internet-connected device
iptables -A FORWARD -i ens33 -o br0 -j ACCEPT
ip route add 140.113.100.0/24 via 0.0.0.0 dev br0
ip route add 140.114.100.0/24 via 0.0.0.0 dev br0
ip route add 140.128.100.0/24 via 0.0.0.0 dev br0
iptables -t nat -A POSTROUTING -s 10.33.55.1/24 -o ens33 -j MASQUERADE # IP Masquerading
ip netns exec nsA iptables -t nat -A POSTROUTING -s 140.113.100.254/24 -o nsA-eth0 -j MASQUERADE
ip netns exec nsNYCU iptables -t nat -A POSTROUTING -s 140.114.100.254/24 -o nsNYCU-eth0 -j MASQUERADE
ip netns exec nsNYCU iptables -t nat -A POSTROUTING -s 140.128.100.254/24 -o nsNYCU-eth0 -j MASQUERADE
echo """subnet 10.33.55.0 netmask 255.255.255.0 {
    range 10.33.55.2 10.33.55.3;
    option routers 10.33.55.1;
    authoritative;
}

host nsA_dhcp_client {
  hardware ethernet ${nsA_MAC};
  fixed-address ${nsA_IP_UP};
}

host nsB_dhcp_client {
  hardware ethernet ${nsB_MAC};
  fixed-address ${nsB_IP};
}""" >> /etc/dhcp/dhcpd.conf
systemctl restart isc-dhcp-server
ip netns exec nsA dhclient -v nsA-eth0
ip netns exec nsB dhclient -v nsB-eth0
iptables -A INPUT -p tcp -m tcp --dport 22 -s 103.136.224.0/29 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -s 103.136.224.8/29 -j REJECT
iptables -A FORWARD -d 103.136.225.150 -o br0 -j REJECT
iptables -A PREROUTING -t nat -p tcp --dport 7777 -j DNAT --to-destination 10.33.55.2:8888
iptables -A FORWARD -p tcp -d 10.33.55.2 --dport 8888 -j ACCEPT