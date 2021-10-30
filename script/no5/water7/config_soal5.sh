apt-get update
apt-get install bind9 -y
echo 'zone "franky.b07.com" {
    type slave;
    masters { 192.180.2.2; }; // Masukan IP EniesLobby tanpa tanda petik
    file "/var/lib/bind/franky.b07.com";
};' > /etc/bind/named.conf.local
service bind9 restart
