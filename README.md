# Jarkom-Modul-2-B07-2021

**Anggota kelompok**:

- Salman Damai Alfariq (05111840000159)
- Ridho Ajiraga Jagiswara (05111940000170)
- David Ralphwaldo Martuaraja (05111940000190)

---

## Prefix IP

Prefix IP dari kelompok kami adalah `192.180`

## Soal 1

EniesLobby akan dijadikan sebagai DNS Master, Water7 akan dijadikan DNS Slave, dan Skypie akan digunakan sebagai Web Server. Terdapat 2 Client yaitu Loguetown, dan Alabasta. Semua node terhubung pada router Foosha, sehingga dapat mengakses internet.

### Pembahasan
1. Pertama dilakukan pembuatan node dan dihubungkan hingga sesuai dengan ketentuan soal  

![node](https://user-images.githubusercontent.com/75240358/139521628-d6b6edc8-c0e9-4da8-8eb2-577a7cc9f0e0.png)

2. Kemudian melakukan Edit network configuration pada setiap node :  
    a. Foosha
    ```
    auto eth0
    iface eth0 inet dhcp

    auto eth1
    iface eth1 inet static
	  address 192.180.1.1
	  netmask 255.255.255.0

    auto eth2
    iface eth2 inet static
	  address 192.180.2.1
	  netmask 255.255.255.0
    ```

    b. Loguetown
    ```
    auto eth0
    iface eth0 inet static
	  address 192.180.1.2
	  netmask 255.255.255.0
	  gateway 192.180.1.1
    ```
    c. Alabasta
    ```
    auto eth0
    iface eth0 inet static
	  address 192.180.1.3
	  netmask 255.255.255.0
	  gateway 192.180.1.1
    ```
    d. EniesLobby
    ```
    auto eth0
    iface eth0 inet static
	  address 192.180.2.2
	  netmask 255.255.255.0
	  gateway 192.180.2.1
    ```
    e. Water7
    ```
    auto eth0
    iface eth0 inet static
	  address 192.180.2.3
	  netmask 255.255.255.0
	  gateway 192.180.2.1
    ```
    f. Skypie
    ```
    auto eth0
    iface eth0 inet static
	  address 192.180.2.4
	  netmask 255.255.255.0
	  gateway 192.180.2.1
    ```
3. Lalu merestart semua node
4. Kemudian setting iptables dengan `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.180.0.0/16` pada router `Foosha`
5. Mengetikkan command `cat /etc/resolv.conf` di `Foosha`

![set_nameserver](https://user-images.githubusercontent.com/75240358/139521643-0e4ad7cf-1be0-4c2f-a289-6ee5025d8b0c.png)

6. Mensetting nameserver pada semua node sesuai dengan IP yang didapatkan menggunakan command `echo nameserver 192.168.122.1 > /etc/resolv.conf`
7. Melakukan tes dengan `ping google.com` pada setiap node untuk mengecek apakah node telah tersambung ke internet

## Soal 2

Luffy ingin menghubungi Franky yang berada di EniesLobby dengan denden mushi. Kalian diminta Luffy untuk membuat website utama dengan mengakses **franky.b07.com** dengan alias **www.franky.b07.com** pada folder kaizoku

### Pembahasan
1. Pada Enieslobby, pertama dilakukan install bind9 dengan menggunakan command `apt-get update` dan `apt-get install bind9 -y`
2. Kemudian mengedit isi dari file `/etc/bind/named.conf.local` seperti berikut:
```
   zone "franky.b07.com" {
        type master;
        file "/etc/bind/kaizoku/franky.b07.com";
};
```
3. Membuat direktori baru `mkdir /etc/bind/kaizoku`
4. Melakukan copy file `cp /etc/bind/db.local /etc/bind/kaizoku/franky.b07.com`
5. Mengedit isi file `/etc/bind/kaizoku/franky.b07.com` seperti berikut:
```
;
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
```
6. Melakukan restart bind9 dengan `service bind9 restart`
7. Melakukan setting nameserver pada client **Loguetown** dan **Alabasta** dengan 
```
echo 'nameserver 192.180.2.2 # IP EniesLobby
' > /etc/resolv.conf
```
8. Melakukan tes di Loguetown `ping franky.b07.com` dan `ping www.franky.b07.com`, jika IP nya `192.180.2.2` artinya DNS telah terkoneksi

## Soal 3

Setelah itu buat subdomain **super.franky.b07.com** dengan alias www.super.franky.b07.com yang diatur DNS nya di EniesLobby dan mengarah ke Skypie

### Pembahasan
1. Pada **Enieslobby** dilakukan edit file `/etc/bind/kaizoku/franky.b07.com` seperti berikut:
```
;
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
super   IN      A       192.180.2.4 ;IP Skyepie
www.super     IN      CNAME   super.franky.b07.com.
```
2. Melakukan restart bind9 dengan `service bind9 restart`
3. Melakukan tes di Loguetown `ping super.franky.b07.com` dan `ping www.super.franky.b07.com`, jika IP nya `192.180.2.4` artinya DNS telah terkoneksi

## Soal 4

Buat juga reverse domain untuk domain utama

### Pembahasan
1. Pada **Enieslobby** pertama-tama edit file `/etc/bind/named.conf.local` seperti berikut:
```
zone "franky.b07.com" {
        type master;
        file "/etc/bind/kaizoku/franky.b07.com";
};

zone "2.180.192.in-addr.arpa" {
    type master;
    file "/etc/bind/kaizoku/2.180.192.in-addr.arpa";
};
```
2. Mengcopy file dengan `cp /etc/bind/db.local /etc/bind/kaizoku/2.180.192.in-addr.arpa`
3. Mengedit file `/etc/bind/kaizoku/2.180.192.in-addr.arpa` seperti berikut:
```
;
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
```
4. Melakukan restart bind9 dengan `service bind9 restart`
5. Pada **Loguetown** lakukan `apt-get update` dan `apt-get install dnsutils`
6. Kemudian lakukan `host -t PTR 192.180.2.2` untuk mengecek apakah reverse domain mengarah ke domain utama

## Soal 5

Supaya tetap bisa menghubungi Franky jika server EniesLobby rusak, maka buat Water7 sebagai DNS Slave untuk domain utama

### Pembahasan
1. Pertama pada **Enieslobby** edit file `/etc/bind/named.conf.local` seperti berikut:
```
zone "franky.b07.com" {
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
```
2. Kemudian lakukan `service bind9 restart`
3. Pada **Water7** lakukan `apt-get update` dan `apt-get install bind9 -y`
4. Lalu edit file `/etc/bind/named.conf.local` menjadi seperti berikut:
```
zone "franky.b07.com" {
    type slave;
    masters { 192.180.2.2; }; // Masukan IP EniesLobby tanpa tanda petik
    file "/var/lib/bind/franky.b07.com";
};
```
5. Kemudian lakukan `service bind9 restart`
6. Lalu pada **Loguetown** lakukan 
```
echo 'nameserver 192.180.2.2 # IP EniesLobby
nameserver 192.180.2.3 # IP Water7
' > /etc/resolv.conf
```
7. Untuk mencobanya, matikan service bind9 dengan `service bind9 stop` pada **Enieslobby**
8. Kemudian coba lakukan `ping franky.b07.com` pada **Loguetown**, jika bisa maka pembuatan DNS Slave telah berhasil

## Soal 6

Setelah itu terdapat subdomain **mecha.franky.b07.com** dengan alias www.mecha.franky.b07.com yang didelegasikan dari EniesLobby ke Water7 dengan IP menuju ke Skypie dalam folder sunnygo

### Pembahasan
1. Pertama pada **Enieslobby** edit file `/etc/bind/kaizoku/franky.b07.com` seperti berikut:
```
;
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
```
2. Kemudian pada file `/etc/bind/named.conf.options` ubah menjadi seperti berikut:
```
options {
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
};
```
3. Lalu pada file `/etc/bind/named.conf.local` ubah menjadi seperti berikut:
```
zone "franky.b07.com" {
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
```
4. Kemudian lakukan `service bind9 restart`
5. Selanjutnya di **Water7** ubah file `/etc/bind/named.conf.options` seperti berikut:
```
options {
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
};
```
6. Pada file `/etc/bind/named.conf.local` ubah menjadi:
```
zone "franky.b07.com" {
    type slave;
    masters { 192.180.2.2; }; // Masukan IP EniesLobby tanpa tanda petik
    file "/var/lib/bind/franky.b07.com";
};

zone "mecha.franky.b07.com" {
        type master;
        file "/etc/bind/sunnygo/mecha.franky.b07.com";  //delegasi subdomain mecha dari EniesLobby
};
```
7. Kemudian buat direktori `/sunnygo` dengan command `mkdir /etc/bind/sunnygo`
8. Lakukan copy file dengan command `cp /etc/bind/db.local /etc/bind/sunnygo/mecha.franky.b07.com`
9. Lalu pada file `/etc/bind/sunnygo/mecha.franky.b07.com` edit menjadi seperti berikut:
```
;
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
```
10. Lakukan `service bind9 restart`
11. Terakhir tes "ping www.mecha.franky.b07.com" di **Loguetown**, jika IP nya `192.180.2.4` artinya delegasi telah berhasil

## Soal 7

Untuk memperlancar komunikasi Luffy dan rekannya, dibuatkan subdomain melalui Water7 dengan nama **general.mecha.franky.b07.com** dengan alias www.general.mecha.franky.b07.com yang mengarah ke Skypie

### Pembahasan
1. Pada **Water7** edit file `/etc/bind/sunnygo/mecha.franky.b07.com` menjadi seperti berikut:
```
;
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
```
2. Kemudian lakukan `service bind9 restart`
3. Lalu lakukan tes pada **Loguetown** `ping www.general.mecha.franky.b07.com`, jika IP nya `192.180.2.4` artinya telah berhasil
