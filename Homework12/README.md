# Практика с SELinux.
# 1. Запустить nginx на нестандартном порту 3-мя разными способами:  
- переключатели setsebool;  
- добавление нестандартного порта в имеющийся тип;  
- формирование и установка модуля SELinux.
1. Установим nginx, поменяем порт в конфиге на отличный от стандартного (скрин конфига)

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic1.png)

Проверим, что сервис не запускается с таким портом:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic2.png)

2. Установим  пакет yum install setools-console.x86_64 и setroubleshoot, yum install -y setroubleshoot-server.x86_64

3. При помощи команды sealert  проверим возможные варианты решения проблемы и проверим каждый из них:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic3.png)

4. Сначала проверим при помощи команды setsebool. Проверим состояние параметра:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic4.png)

5. Изменим состояние параметра на on (1) и проверим запуск сервиса:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic5.png)Как видим сервис запустился.

**Теперь вернем параметр в исходное состояние и проверим другой вариант - добавление нестандартного порта в имеющийся тип.**

1. Проверим, что все вернули в исходное состояние:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic6.png)

2. Добавим порт в тип и проверим его в списке разрешенных портов для типа http_port_t:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic7.png)

Сервис запустился.

**Вернем параметр в исходное состояние и проверим другой вариант - формирование и установка собственного модуля SELinux.**

Удалим порт из типа:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic8.png)

Создадим свой модуль с помощью команд ausearch  и semodule:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic9.png)

Сервис запустился.

# Задание 2.

**Первый вариант решения проблемы - проверка и исправление правил SELinux.**
Проверим ошибки Selinux при помощи audit2why и audit2allow, для этого переведем SElinux  в статус Permissive  и проверим работает ли обновление зоны:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic10.png)

Потом по рекомендации добавим модуль и проверим с клиента работу с SElinux  в режиме enforcing:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic11.png)

**Второй вариант решения проблемы - проверить и исправить конфигурационные файлы сервиса, в таком случае нет необоходимости вносить изменения в SELinux**
Проверим имеюющиеся правила SELinux для сервиса named:
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/pic/pic12.png) 
Тут мы можем увидеть где SElinux ожидает увидеть файлы данного сервиса. Теперь можно сравнить с конфигурационным файлом и исправить.

Итоговый вид конфигурационного файлы ```named.conf```:

```
options {
    // network
        listen-on port 53 { 192.168.50.10; };
        // listen-on-v6 port 53 { ::1; };

    // data
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";

    // server
        recursion yes;
        allow-query     { any; };
    allow-transfer { any; };

    // dnssec
        dnssec-enable yes;
        dnssec-validation yes;

    // others
        bindkeys-file "/etc/named.iscdlv.key";
        managed-keys-directory "/var/named/dynamic";
        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

// RNDC Control for client
key "rndc-key" {
    algorithm hmac-md5;
    secret "GrtiE9kz16GK+OKKU/qJvQ==";
};

controls {
        inet 192.168.50.10 allow { 192.168.50.15; } keys { "rndc-key"; };
};

acl "view1" {
    192.168.50.15/32; // client
};

// ZONE TRANSFER WITH TSIG
include "/etc/named.zonetransfer.key";

view "view1" {
    match-clients { "view1"; };

    // root zone
    zone "." IN {
        type hint;
        file "named.ca";
    };

    // zones like localhost
    include "/etc/named.rfc1912.zones";
    // root DNSKEY
    include "/etc/named.root.key";

    // labs dns zone
    zone "dns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        file "/var/named/named.dns.lab.view1";
    };

    // labs ddns zone
    zone "ddns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        allow-update { key "zonetransfer.key"; };
        file "/var/named/dynamic/named.ddns.lab.view1";
    };

    // labs newdns zone
    zone "newdns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        file "/var/named/named.newdns.lab";
    };

    // labs zone reverse
    zone "50.168.192.in-addr.arpa" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        file "/var/named/named.50.168.192.rev";
    };
};

view "default" {
    match-clients { any; };

    // root zone
    zone "." IN {
        type hint;
        file "named.ca";
    };

    // zones like localhost
    include "/etc/named.rfc1912.zones";
    // root DNSKEY
    include "/etc/named.root.key";

    // labs dns zone
    zone "dns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        file "/var/named/named.dns.lab";
    };

    // labs ddns zone
    zone "ddns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        allow-update { key "zonetransfer.key"; };
        file "/var/named/dynamic/named.ddns.lab";
    };

    // labs newdns zone
    zone "newdns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        file "/var/named/named.newdns.lab";
    };

    // labs zone reverse
    zone "50.168.192.in-addr.arpa" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        file "/var/named/named.50.168.192.rev";
    };
};

```
Если его сравнить с оригинальным, то увидим, что ошибка была в том, что файлы были в директории ```etc```, а не в ```var```, как должны были. 

Также необходимо поправить playbook, чтобы файлы копировались в нужную директорию. 
Исправленный стенд располанается по [ссылке](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/SElinuxLab)

