echo 'options {
        directory "/var/cache/bind";

        // If there is a firewall between you and nameservers you want
        // to talk to, you may need to fix the firewall to allow multiple
        // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

        // If your ISP provided one or more IP addresses for stable
        // nameservers, you probably want to use them as forwarders.
        // Uncomment the following block, and insert the addresses replacing
        // the all-0s placeholder.

        // forwarders {
        //      0.0.0.0;
        // };

        //=======================================================================
 // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //=======================================================================
        // dnssec-validation auto;
        allow-query{any;};

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};' > /etc/bind/named.conf.options

echo 'zone "franky.b07.com" {
    type slave;
    masters { 192.180.2.2; }; // Masukan IP EniesLobby tanpa tanda petik
    file "/var/lib/bind/franky.b07.com";
};

zone "mecha.franky.b07.com" {
        type master;
        file "/etc/bind/sunnygo/mecha.franky.b07.com";  //delegasi subdomain mecha dari EniesLobby
};' > /etc/bind/named.conf.local

mkdir /etc/bind/sunnygo

cp /etc/bind/db.local /etc/bind/sunnygo/mecha.franky.b07.com

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
' > /etc/bind/sunnygo/mecha.franky.b07.com
service bind9 restart