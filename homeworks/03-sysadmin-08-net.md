## Задание 1
Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP.

**Ответ**:
```commandline
route-views>show ip route 91.223.199.99 
Routing entry for 91.223.199.0/24
  Known via "bgp 6447", distance 20, metric 0
  Tag 8283, type external
  Last update from 94.142.247.3 6d18h ago
  Routing Descriptor Blocks:
  * 94.142.247.3, from 94.142.247.3, 6d18h ago
      Route metric is 0, traffic share count is 1
      AS Hops 4
      Route tag 8283
      MPLS label: none
route-views>show bgp 91.223.199.99     
BGP routing table entry for 91.223.199.0/24, version 323941630
Paths: (22 available, best #22, table default)
  Not advertised to any peer
  Refresh Epoch 1
  3333 1103 31133 35591 35591
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      path 7FE0DDFCEE28 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 174 31133 35591 35591
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin IGP, localpref 100, valid, external
      Community: 101:20100 101:20110 101:22100 174:21101 174:22028
      Extended Community: RT:101:22100
      path 7FE145DB0AE8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3303 31133 35591 35591
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 3303:1004 3303:1006 3303:1030 3303:3056
      path 7FE07D66EB18 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1221 4637 31133 35591 35591
    203.62.252.83 from 203.62.252.83 (203.62.252.83)
      Origin IGP, localpref 100, valid, external
      path 7FE13BBB2148 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 31133 35591 35591
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE10E6892E8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 31133 35591 35591
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin IGP, localpref 100, valid, external
      Community: 174:21101 174:22028 53767:5000
      path 7FE12A032A90 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 3356 3216 35591 35591
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8070 3257:30515 3257:50001 3257:53900 3257:53902 20912:65004
      path 7FE116085C68 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1351 6939 3216 35591 35591
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE15CC32340 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 3216 35591 35591
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3216:2001 3216:4423 3356:2 3356:22 3356:100 3356:123 3356:503 3356:901 3356:2067
      path 7FE12C64BEB8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 3216 35591 35591
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3216:2001 3216:4423 3356:2 3356:22 3356:100 3356:123 3356:503 3356:901 3356:2067 3549:2581 3549:30840
      path 7FE0B6F397C0 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  701 1273 3216 35591 35591
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin IGP, localpref 100, valid, external
      path 7FE0E4566AB0 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 2
  2497 3216 35591 35591
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin IGP, localpref 100, valid, external
      path 7FE13F1E4260 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 3356 3216 35591 35591
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin IGP, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE035B391C8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  49788 12552 31133 35591 35591
    91.218.184.60 from 91.218.184.60 (91.218.184.60)
      Origin IGP, localpref 100, valid, external
      Community: 12552:12000 12552:12100 12552:12101 12552:22000
      Extended Community: 0x43:100:1
      path 7FE0E0C3C390 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 3356 3216 35591 35591
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3216:2001 3216:4423 3356:2 3356:22 3356:100 3356:123 3356:503 3356:901 3356:2067
      path 7FE0E0C3F410 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 1273 3216 35591 35591
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external
      Community: 2516:1030 7660:9001
      path 7FE0F43F4910 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20130 6939 3216 35591 35591
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external
      path 7FE1883703E8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  6939 3216 35591 35591
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external
      path 7FE0A762E760 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3561 3910 3356 3216 35591 35591
    206.24.210.80 from 206.24.210.80 (206.24.210.80)
      Origin IGP, localpref 100, valid, external
      path 7FDFFBF51B08 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3257 1299 3216 35591 35591
    89.149.178.10 from 89.149.178.10 (213.200.83.26)
      Origin IGP, metric 10, localpref 100, valid, external
      Community: 3257:8794 3257:30052 3257:50001 3257:54900 3257:54901
      path 7FE09BB6E648 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  852 31133 35591 35591
    154.11.12.212 from 154.11.12.212 (96.1.209.43)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE129C62F58 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 2
  8283 3216 35591 35591
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external, best
      Community: 3216:2001 3216:4423 8283:1 8283:101 8283:103 65000:52254
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x24
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001 0000 205B 0000 0005
              0000 0003 
      path 7FE158AD85A8 RPKI State valid
      rx pathid: 0, tx pathid: 0x0
```

## Задание 2
Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

**Ответ**:
```commandline
echo "dummy" >> /etc/modules
echo "options dummy numdummies=2" > /etc/modprobe.d/dummy.conf
vim /etc/network/interfaces
auto dummy0
iface dummy0 inet static
address 10.0.2.21/24
pre-up ip link add dummy0 type dummy
post-down ip link del dummy0
```
Посмотрим загрузился ли модуль, создались ли интерфейсы:
```commandline
vagrant@vagrant:~$ lsmod | grep dummy
dummy                  16384  0
vagrant@vagrant:~$ ip a | grep dummy
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
4: dummy1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
```
Перегружаем ВМ.

```commandline
vagrant@vagrant:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 86366sec preferred_lft 86366sec
    inet6 fe80::a00:27ff:feb1:285d/64 scope link 
       valid_lft forever preferred_lft forever
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether f2:af:64:bd:31:6b brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.21/24 brd 10.0.2.255 scope global dummy0
       valid_lft forever preferred_lft forever
    inet6 fe80::f0af:64ff:febd:316b/64 scope link 
       valid_lft forever preferred_lft forever
$ ip route show
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
10.0.2.0/24 dev dummy0 proto kernel scope link src 10.0.2.21 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
```
Добавляем временные статические маршруты:
```commandline
vagrant@vagrant:~$ sudo ip route add 10.0.3.0/24 dev dummy0
vagrant@vagrant:~$ sudo ip route add 192.168.0.0/24 dev dummy0
vagrant@vagrant:~$ ip route show
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
10.0.2.0/24 dev dummy0 proto kernel scope link src 10.0.2.21 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
10.0.3.0/24 dev dummy0 scope link 
192.168.0.0/24 dev dummy0 scope link 
```
## Задание 3
Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

**Ответ**:

Ситуация интересная.  Командой `ss -ltpn` я вижу одно количество портов (скорее всего это скан изнутри, показывает прослушиваемые порты системы). Порты 631 и 53 извне недоступны т.к. адрес 127.0.0.х. Остальные должны быть доступны извне.
```commandline
$ ss -ltpn
State   Recv-Q  Send-Q        Local Address:Port      Peer Address:Port  Process                           
LISTEN  0       4096                0.0.0.0:40855          0.0.0.0:*                                       
LISTEN  0       5                 127.0.0.1:631            0.0.0.0:*                                       
LISTEN  0       4096                0.0.0.0:38493          0.0.0.0:*                                       
LISTEN  0       64                  0.0.0.0:2049           0.0.0.0:*                                       
LISTEN  0       4096                0.0.0.0:54277          0.0.0.0:*                                       
LISTEN  0       16                  0.0.0.0:8200           0.0.0.0:*                                       
LISTEN  0       4096                0.0.0.0:111            0.0.0.0:*                                       
LISTEN  0       64                  0.0.0.0:35861          0.0.0.0:*                                       
LISTEN  0       4096          127.0.0.53%lo:53             0.0.0.0:*                                       
LISTEN  0       4096                   [::]:47831             [::]:*                                       
LISTEN  0       5                     [::1]:631               [::]:*                                       
LISTEN  0       64                     [::]:42653             [::]:*                                       
LISTEN  0       4096     [::ffff:127.0.0.1]:6942                 *:*      users:(("java",pid=2834,fd=30))  
LISTEN  0       64                     [::]:2049              [::]:*                                       
LISTEN  0       4096                   [::]:41225             [::]:*                                       
LISTEN  0       4096     [::ffff:127.0.0.1]:63342                *:*      users:(("java",pid=2834,fd=49))  
LISTEN  0       4096                   [::]:111               [::]:*                                       
LISTEN  0       4096                   [::]:35061             [::]:*             
```
Но, если сканировать по IP командой `nmap -sV`, то список будет другим:
```commandline
$ sudo nmap -sV 192.168.0.109
Starting Nmap 7.80 ( https://nmap.org ) at 2022-03-06 09:10 +03
Nmap scan report for leonid-P85-D3 (192.168.0.109)
Host is up (0.0000030s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE VERSION
111/tcp  open  rpcbind 2-4 (RPC #100000)
2049/tcp open  nfs_acl 3 (RPC #100227)
8200/tcp open  upnp    MiniDLNA 1.2.1 (OS: Ubuntu; DLNADOC 1.50; UPnP 1.0)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 6.44 seconds
```

Ключ `-sV` исследует открытые порты для определения информации об услуге / версии. Но портов намного меньше чем при сканировании командой `ss -ltpn`

Порты могут быть не только открытыми или закрытыми. Из-за особенностей передачи пакетов и ответов на них разными протоколами для более точного определения состояния исследуемой цели Nmap выделяет шесть состояний портов, их надо знать для понимания полученных результатов сканирования:
* **open** Открыт. Приложение принимает на порт пакет или запросы на соединение.
* **closed** Закрыт. Порт отвечает на запросы, но не используется никаким приложением.
* **filtered** Фильтруется. Запросы не доходят до этого порта, а значит, невозможно определить, открыт он или нет.
* **unfiltered** Не фильтруется. Порт доступен, но Nmap не может определить, закрыт он или открыт. Как правило, помогает использование другого способа сканирования.
* **open|filtered** Открыт|фильтруется. Nmap помещает порты в это состояние, когда не может определить, открыт порт или отфильтрован. Это происходит для типов сканирования, при которых открытые порты не дают ответа. Отсутствие ответа может также означать, что пакетный фильтр отклонил зонд или какой-либо ответ, который он вызвал. Таким образом, Nmap не знает наверняка, открыт порт или фильтруется. Сканирование UDP, IP-протокола, FIN, NULL и Xmas классифицирует порты таким образом.
* **closed|filtered** Закрыт|фильтруется. Не получается определить, закрыт порт или фильтруется. Как правило, помогает использование другого способа сканирования.

Т.к. по заданию требуется показать только открытые порты, их протоколы и приложения их использующие, то нам нужен результат команды `sudo nmap -sV 192.168.0.109`
```commandline
$ sudo nmap -sV 192.168.0.109
Starting Nmap 7.80 ( https://nmap.org ) at 2022-03-06 09:10 +03
Nmap scan report for leonid-P85-D3 (192.168.0.109)
Host is up (0.0000030s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE VERSION
111/tcp  open  rpcbind 2-4 (RPC #100000)
2049/tcp open  nfs_acl 3 (RPC #100227)
8200/tcp open  upnp    MiniDLNA 1.2.1 (OS: Ubuntu; DLNADOC 1.50; UPnP 1.0)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 6.44 seconds
```

*nfs* -  сетевая файловая система, позволяющая пользователям обращаться к файлам и каталогам. Я её не использую, файл `/etc/exports` - пустой. Удалил у себя
```commandline
sudo service rpcbind stop
sudo apt-get remove rpcbind
```
После:
```commandline
$ sudo nmap -sV 192.168.0.109
Starting Nmap 7.80 ( https://nmap.org ) at 2022-03-06 10:57 +03
Nmap scan report for leonid-P85-D3 (192.168.0.109)
Host is up (0.0000020s latency).
Not shown: 999 closed ports
PORT     STATE SERVICE VERSION
8200/tcp open  upnp    MiniDLNA 1.2.1 (OS: Ubuntu; DLNADOC 1.50; UPnP 1.0)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 6.38 seconds
```
## Задание 4
Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

**Ответ**:
```commandline
$ ss -lupn
State   Recv-Q  Send-Q     Local Address:Port      Peer Address:Port  Process                              
UNCONN  0       0                0.0.0.0:631            0.0.0.0:*                                          
UNCONN  0       0        239.255.255.250:1900           0.0.0.0:*                                          
UNCONN  0       0          192.168.0.109:53962          0.0.0.0:*                                          
UNCONN  0       0                0.0.0.0:37952          0.0.0.0:*                                          
UNCONN  0       0            224.0.0.251:5353           0.0.0.0:*      users:(("chrome",pid=2310,fd=70))   
UNCONN  0       0            224.0.0.251:5353           0.0.0.0:*      users:(("chrome",pid=2259,fd=161))  
UNCONN  0       0                0.0.0.0:5353           0.0.0.0:*                                          
UNCONN  0       0          127.0.0.53%lo:53             0.0.0.0:*                                          
UNCONN  0       0                   [::]:45595             [::]:*                                          
UNCONN  0       0                   [::]:5353              [::]:*   

$ sudo nmap -sU 192.168.0.109
Starting Nmap 7.80 ( https://nmap.org ) at 2022-03-06 11:12 +03
Nmap scan report for leonid-P85-D3 (192.168.0.109)
Host is up (0.0000070s latency).
Not shown: 998 closed ports
PORT     STATE         SERVICE
631/udp  open|filtered ipp
5353/udp open|filtered zeroconf
```
* **ipp** - интернет протокол печати. Использует сервер печати CUPS - управляет заданиями печати и обеспечивает сетевую печать с использованием стандарта IPP. 
* **Zeroconf** — это протокол, разработанный Apple и призванный решать следующие проблемы:
  * выбор сетевого адреса для устройства;
  * нахождение компьютеров по имени;
  * обнаружение сервисов, например принтеров.

## Задание 5
Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.

**Ответ**: [network.xml](xml/network.xml)
