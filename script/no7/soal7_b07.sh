echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     mecha.franky.b07.com. root.mecha.franky.b07.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      mecha.franky.b07.com.
@       IN      A       192.180.2.4    ; IP Skypie
www     IN      CNAME   mecha.franky.b07.com.
general 	IN      A       192.180.2.4     ; IP Skypie
www.general	IN	CNAME	general.mecha.franky.b07.com.
' > /etc/bind/sunnygo/mecha.franky.b07.com
service bind9 restart