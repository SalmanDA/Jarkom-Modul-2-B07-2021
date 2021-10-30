# Jarkom-Modul-2-B07-2021

**Anggota kelompok**:

- Salman Damai Alfariq (05111840000159)
- Ridho Ajiraga Jagiswara (05111940000170)
- David Ralphwaldo Martuaraja (05111940000190)

---

## Prefix IP

Prefix IP dari kelompok kami adalah `192.180`

## Soal 1

EniesLobby akan dijadikan sebagai DNS Master, Water7 akan dijadikan DNS Slave, dan Skypie akan digunakan sebagai Web Server. Terdapat 2 Client yaitu Loguetown, dan Alabasta. Semua node terhubung pada router Foosha, sehingga dapat mengakses internet 

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

## Soal 3

Setelah itu buat subdomain **super.franky.b07.com** dengan alias www.super.franky.b07.com yang diatur DNS nya di EniesLobby dan mengarah ke Skypie

### Pembahasan

## Soal 4

Buat juga reverse domain untuk domain utama

### Pembahasan

## Soal 5

Supaya tetap bisa menghubungi Franky jika server EniesLobby rusak, maka buat Water7 sebagai DNS Slave untuk domain utama

### Pembahasan

## Soal 6

Setelah itu terdapat subdomain **mecha.franky.b07.com** dengan alias www.mecha.franky.b07.com yang didelegasikan dari EniesLobby ke Water7 dengan IP menuju ke Skypie dalam folder sunnygo

### Pembahasan

## Soal 7

Untuk memperlancar komunikasi Luffy dan rekannya, dibuatkan subdomain melalui Water7 dengan nama **general.mecha.franky.b07.com** dengan alias www.general.mecha.franky.b07.com yang mengarah ke Skypie

### Pembahasan
