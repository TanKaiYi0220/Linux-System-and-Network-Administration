br0_IP=10.33.55.1
nsA_IP=10.33.55.2
nsB_IP=10.33.55.3
ip netns add nsA
ip netns add nsB
ip link add nsA-eth0 type veth peer name host-nsA
ip link add nsB-eth0 type veth peer name host-nsB
ip link set nsA-eth0 netns nsA
ip link set nsB-eth0 netns nsB
ip netns exec nsA ip addr add 10.33.55.2/24 dev nsA-eth0 # dev: device
ip netns exec nsB ip addr add 10.33.55.3/24 dev nsB-eth0
ip netns exec nsA ip link set nsA-eth0 up
ip netns exec nsA ip link set lo up # lo: loopback device
ip netns exec nsB ip link set nsB-eth0 up
ip netns exec nsB ip link set lo up
ip link add name br0 type bridge
ip link set host-nsA master br0
ip link set host-nsB master br0
ip addr add 10.33.55.1/24 brd + dev br0 # brd: broadcast
ip link set host-nsA up
ip link set host-nsB up
ip link set br0 up
default_DEV=$(ip route | awk '/default/ { print $5 }')
nsA_MAC=$(ip netns exec nsA ip link show nsA-eth0 | awk '/ether/ {print $2}')
nsB_MAC=$(ip netns exec nsB ip link show nsB-eth0 | awk '/ether/ {print $2}')
ip netns exec nsA ip route add default via 10.33.55.1
ip netns exec nsB ip route add default via 10.33.55.1
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -o ens33 -i br0 -j ACCEPT # ens33 depend on Internet-connected device
iptables -A FORWARD -i ens33 -o br0 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.33.55.1/24 -o ens33 -j MASQUERADE # IP Masquerading
echo """subnet 10.33.55.0 netmask 255.255.255.0 {
    range 10.33.55.2 10.33.55.3;
    option routers 10.33.55.1;
    authoritative;
}

host test_dhcp_client {
  hardware ethernet $nsA_MAC;
  fixed-address $nsA_IP;
}""" >> /etc/dhcp/dhcpd.conf
systemctl start isc-dhcp-server
ip netns exec nsA dhclient nsA-eth0
iptables -A INPUT -p tcp -m tcp --dport 22 -s 103.136.224.0/29 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -s 103.136.224.8/29 -j REJECT
iptables -A FORWARD -d 103.136.225.150 -o br0 -j REJECT
iptables -A PREROUTING -t nat -p tcp --dport 7777 -j DNAT --to-destination 10.33.55.2:8888
iptables -A FORWARD -p tcp -d 10.33.55.2 --dport 8888 -j ACCEPT