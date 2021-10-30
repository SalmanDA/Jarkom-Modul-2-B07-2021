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
};' > /etc/bind/named.conf.local
service bind9 restart