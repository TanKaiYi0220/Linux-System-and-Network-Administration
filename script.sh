ip netns add nsA
ip netns add nsB
ip link add nsA-eth0 type veth peer name host-nsA
ip link add nsB-eth0 type veth peer name host-nsB
ip link set nsA-eth0 netns nsA
ip link set nsB-eth0 netns nsB
ip netns exec nsA ip addr add 10.233.55.2/24 dev nsA-eth0 # dev: device
ip netns exec nsB ip addr add 10.233.55.3/24 dev nsB-eth0
ip netns exec nsA ip link set nsA-eth0 up
ip netns exec nsA ip link set lo up # lo: loopback device
ip netns exec nsB ip link set nsB-eth0 up
ip netns exec nsB ip link set lo up
ip link add name br0 type bridge
ip link set host-nsA master br0
ip link set host-nsB master br0
ip addr add 10.233.55.1/24 brd + dev br0 # brd: broadcast
ip link set host-nsA up
ip link set host-nsB up
ip link set br0 up
ip netns exec nsA ip route add default via 10.233.55.1
ip netns exec nsB ip route add default via 10.233.55.1
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -o ens33 -i br0 -j ACCEPT # ens33 depend on Internet-connected device
iptables -A FORWARD -i ens33 -o br0 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.233.55.1/24 -o ens33 -j MASQUERADE # IP Masquerading