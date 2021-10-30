echo 'zone "franky.b07.com" {
        type master;
        file "/etc/bind/kaizoku/franky.b07.com";
};
' > /etc/bind/named.conf.local
mkdir /etc/bind/kaizoku
cp /etc/bind/db.local /etc/bind/kaizoku/franky.b07.com
echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     franky.b07.com. root.franky.b07.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      franky.b07.com.
@       IN      A       192.180.2.2 ;IP Enieslobby
www     IN      CNAME   franky.b07.com.
' > /etc/bind/kaizoku/franky.b07.com
service bind9 restart