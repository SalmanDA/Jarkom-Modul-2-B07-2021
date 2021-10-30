echo 'zone "franky.b07.com" {
        type master;
        file "/etc/bind/kaizoku/franky.b07.com";
};

zone "2.180.192.in-addr.arpa" {
    type master;
    file "/etc/bind/kaizoku/2.180.192.in-addr.arpa";
};' > /etc/bind/named.conf.local
cp /etc/bind/db.local /etc/bind/kaizoku/2.180.192.in-addr.arpa
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
2.180.192.in-addr.arpa. IN      NS      franky.b07.com.
2                       IN      PTR     franky.b07.com.       ; BYTE KE-4 IP En$
' > /etc/bind/kaizoku/2.180.192.in-addr.arpa
service bind9 restart