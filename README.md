# Convert Markdown to Scripts
Get the corresponding script.sh from `markdown` file. It will extract terminal commands except the title which is **TESTING**.
```
python main.py -file hw01.md
```
# Homework Description
- [HW01](hw01.md)
- [HW02]()
- [HW03]()
- [HW04]()

# Reset Environment
- HW01
```
ip -all netns delete
ip link delete br0 # br0 which is bridge
ip link delete host-nsA
ip link delete host-nsB
# stores default iptables_backup.conf before this project launched
iptables-restore < default_iptables_backup.conf 
# stores default dhcpd.conf before this project launched
cp /etc/dhcp/default_dhcpd.conf /etc/dhcp/dhcpd.conf
```

# References
* [計算機網路 - Network Namespace](https://hackmd.io/@0xff07/network/https%3A%2F%2Fhackmd.io%2F%400xff07%2FSJzOwViYF#Linux-Bridges-IP-Tables-and-CNI-Plug-Ins---A-Container-Networking-Deepdive)
* [深入理解 iptables 和 netfilter 架构](https://arthurchiao.art/blog/deep-dive-into-iptables-and-netfilter-arch-zh/#42-nat-table%E7%BD%91%E7%BB%9C%E5%9C%B0%E5%9D%80%E8%BD%AC%E6%8D%A2)
* [iptables实用教程（一）：基本概念和原理](https://www.cnblogs.com/foxgab/p/6896957.html)
* [第十二章、網路參數控管者： DHCP 伺服器](https://linux.vbird.org/linux_server/centos6/0340dhcp.php)
* [DHCP tricks with Linux network namespace](http://blog.asiantuntijakaveri.fi/2015/07/dhcp-tricks-with-linux-network-namespace.html)
* [Building containers by hand using namespaces: The net namespace](https://www.redhat.com/sysadmin/net-namespaces)
* [Setting up a Basic DHCP Client and Server in Linux](https://medium.com/swlh/setting-up-a-basic-dhcp-client-and-server-in-linux-9005457df607)
* [IPTables Parameter Options](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security_guide/sect-security_guide-command_options_for_iptables-iptables_parameter_options)
* [How To Add Route on Linux](https://devconnected.com/how-to-add-route-on-linux/)

# YouTube Link
* [Network Namespaces Basics Explained in 15 Minutes](https://youtu.be/j_UUnlVC2Ss)
* [Introduction to Linux Network Namespaces](https://youtu.be/_WgUwUf1d34)