# Домашнее задание Firewalld 

Сценарии iptables:

- реализовать knocking port - centralRouter может попасть на ssh inetrRouter через knock скрипт, пример в материалах
- добавить inetRouter2, который виден(маршрутизируется) с хоста
- запустить nginx на centralServer
- пробросить 80й порт на inetRouter2 8080
- дефолт в инет оставить через inetRouter

Задание 1:
```
При помощи firewalld на inetRouter1 перемещу интерфейс смотрящий на centralRouter в отдельную зону internal и отключим в ней ssh
заметьте vagrant ssh оставляю как есть чтоб нормальный доступ иметь к inetRouter1

Следующие команды делаем на inetRouter1
[root@inetRouter1 vagrant]# systemctl start firewalld - слетают все старые правила, включая маскарадинг, починим

[root@inetRouter1 vagrant]# firewall-cmd --permanent --zone=public --remove-interface=eth1
[root@inetRouter1 vagrant]# firewall-cmd --permanent --zone=internal --add-interface=eth1
[root@inetRouter1 vagrant]# firewall-cmd --permanent --zone=public --add-masquerade && firewall-cmd --reload
[root@inetRouter1 vagrant]# firewall-cmd --zone=internal --permanent --remove-service=ssh && firewall-cmd --reload
----------------------------------------------------------------------------
настроим демон knockd
[root@inetRouter1 vagrant]# yum install libpcap
[root@inetRouter1 vagrant]# rpm -Uvh http://li.nux.ro/download/nux/dextop/el7Server/x86_64/knock-server-0.7-1.el7.nux.x86_64.rpm
Приведем конфиг к нужному виду 

[root@inetRouter1 vagrant]# cat /etc/knockd.conf
[options]
UseSyslog
logfile = /var/log/knockd.log
[OpenSSH]
Sequence = 1111,2222,3333
Seq_timeout = 15
Tcpflags = syn
Command = /bin/firewall-cmd --zone=internal --add-rich-rule="rule family="ipv4" source address="%IP%" service name="ssh" accept"

[CloseSSH]
Sequence = 6666,7777,8888
Seq_timeout = 15
Tcpflags = syn
Command = /bin/firewall-cmd --zone=internal --remove-rich-rule="rule family="ipv4" source address="%IP%" service name="ssh" accept"


Укажем  слушать на нужном порту
[root@inetRouter1 vagrant]# echo 'OPTIONS="-i eth1"' >> /etc/sysconfig/knockd
и запустим

надо не забыть задать пароль пользователю vagrant 
и в /etc/ssh/ssh_config прописать PasswordAuthentication yes
[root@inetRouter1 vagrant]# sshd -T && systemctl restart sshd
----------------------------------------------------------------------------

Попробуем зайти по ssh:

[vagrant@centralRouter ~]$ for x in 1111 2222 3333; do nmap -Pn --host_timeout 201 --max-retries 0 -p $x 192.168.255.1 && sleep 1; done && ssh vagrant@192.168.255.1

Starting Nmap 6.40 ( http://nmap.org ) at 2020-11-25 16:51 UTC
Nmap scan report for 192.168.255.1
Host is up (0.0012s latency).
PORT     STATE    SERVICE
1111/tcp filtered lmsocialserver

Nmap done: 1 IP address (1 host up) scanned in 0.05 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2020-11-25 16:51 UTC
Nmap scan report for 192.168.255.1
Host is up (0.00049s latency).
PORT     STATE    SERVICE
2222/tcp filtered EtherNet/IP-1

Nmap done: 1 IP address (1 host up) scanned in 0.03 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2020-11-25 16:51 UTC
Nmap scan report for 192.168.255.1
Host is up (0.00049s latency).
PORT     STATE    SERVICE
3333/tcp filtered dec-notes

Nmap done: 1 IP address (1 host up) scanned in 0.02 seconds
The authenticity of host '192.168.255.1 (192.168.255.1)' can't be established.
ECDSA key fingerprint is SHA256:rrmwIYX5DWEa1+l7QFbD9HM7nHPlQiHnkwxSbbGhT+8.
ECDSA key fingerprint is MD5:86:28:79:68:1c:3a:98:bf:ee:68:cb:80:37:ee:9e:5a.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.255.1' (ECDSA) to the list of known hosts.
vagrant@192.168.255.1's password:
[vagrant@inetRouter1 ~]$
[vagrant@inetRouter1 ~]$

Успешно!)

```

Задание 2:
```
InetRouter2 доступен с хоста:

[vagrant@centralServer ~]$ ping 192.168.255.5
PING 192.168.255.5 (192.168.255.5) 56(84) bytes of data.
64 bytes from 192.168.255.5: icmp_seq=1 ttl=63 time=0.727 ms
64 bytes from 192.168.255.5: icmp_seq=2 ttl=63 time=2.21 ms
64 bytes from 192.168.255.5: icmp_seq=3 ttl=63 time=1.97 ms
64 bytes from 192.168.255.5: icmp_seq=4 ttl=63 time=1.92 ms


```

Задание 3:
```
[vagrant@centralServer ~]$ curl -I localhost:80
HTTP/1.1 200 OK
Server: nginx/1.16.1
Date: Wed, 25 Nov 2020 16:42:58 GMT
Content-Type: text/html
Content-Length: 4833
Last-Modified: Fri, 16 May 2014 15:12:48 GMT
Connection: keep-alive
ETag: "53762af0-12e1"
Accept-Ranges: bytes


```

Задание 4:
```
Укажем на центальном роутере:
[root@centralRouter vagrant]# ip r del default
[root@centralRouter vagrant]# ip r add default via 192.168.255.5 dev eth2
[root@centralRouter vagrant]#


На inetRouter2 (не работает как должно):

[root@inetRouter2 vagrant]# iptables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 -j DNAT --to-destination 192.168.0.2:80
[root@inetRouter2 vagrant]# iptables -t nat -A POSTROUTING -j MASQUERADE

Комментарий:
При попытке достучаться получаю:
[root@inetRouter2 vagrant]# curl -I 192.168.0.2:8080
curl: (7) Failed connect to 192.168.0.2:8080; Connection refused

По 80-му - ОК

```


Задание 5:
```
По умолчанию имеем следующие маршруты на данный момент:
[vagrant@centralRouter ~]$ ip r
default via 192.168.255.1 dev eth1
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100
192.168.0.0/28 dev eth3 proto kernel scope link src 192.168.0.1 metric 103
192.168.255.0/30 dev eth1 proto kernel scope link src 192.168.255.2 metric 101
192.168.255.4/30 dev eth2 proto kernel scope link src 192.168.255.6 metric 102

Добавим правило, которое пометит все пакеты на порт 80:
iptables -A PREROUTING -i eth2 -t mangle -p tcp --dport 80 -j MARK --set-mark 1

И теперь направим все пакеты с меткой по нужному маршруту через InetRouter1:
echo 201 http.out >> /etc/iproute2/rt_tables
ip rule add fwmark 1 table http.out
ip route add default via 192.168.255.5 dev eth1 table http.out

```
