
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.180.0.0/16

cat /etc/resolv.conf

apt-get update