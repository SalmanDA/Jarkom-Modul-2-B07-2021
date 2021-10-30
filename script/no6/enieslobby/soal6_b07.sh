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
@       	IN      NS      franky.b07.com.
@       	IN      A       192.180.2.2 ;IP Enieslobby
www     	IN      CNAME   franky.b07.com.
super   	IN      A       192.180.2.4 ;IP Skypie
www.super     	IN      CNAME   super.franky.b07.com.
ns1     	IN      A       192.180.2.3 ;IP water7
mecha   	IN      A       ns1
' > /etc/bind/kaizoku/franky.b07.com

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

        //========================================================================
        // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //========================================================================

  	//dnssec-validation auto;
        allow-query{any;};

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};' > /etc/bind/named.conf.options
      
echo 'zone "franky.b07.com" {
        type master;
	notify yes;
	also-notify { 192.180.2.3; }; // Masukan IP Water7 tanpa tanda petik
        allow-transfer { 192.180.2.3; }; // Masukan IP Water7 tanpa tanda petik
        file "/etc/bind/kaizoku/franky.b07.com";
};

zone "2.180.192.in-addr.arpa" {
    type master;
    file "/etc/bind/kaizoku/2.180.192.in-addr.arpa";
};
' > /etc/bind/named.conf.local
service bind9 restart