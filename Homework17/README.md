# Статическая и динамическая маршрутизация, OSPF

OSPF
- Поднять три виртуалки
- Объединить их разными vlan
1. Поднять OSPF между машинами на базе Quagga
2. Изобразить ассиметричный роутинг
3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным

Настройки OSPF прописана в Vagrantfile, конфиги копируются при развертывание.

Для ассиметричного роутинга необходимо поменять стоимость линков:
```
!
interface eth1
 description to_ro2
 ip address 10.0.0.1/30
 ip ospf cost 10
 ip ospf dead-interval 10
 ip ospf hello-interval 5
 ip ospf mtu-ignore
 ip ospf network point-to-point
 ipv6 nd suppress-ra
!
interface eth2
 description to_ro3
 ip address 10.10.0.1/30
 ip ospf cost 20
 ip ospf dead-interval 10
 ip ospf hello-interval 5
 ip ospf mtu-ignore
 ip ospf network point-to-point
 ipv6 nd suppress-ra
!

```

Проверяем количество хопов между ro1 и ro3:
```
[root@ro1 ~]# tracepath 10.20.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.0.0.2                                              0.366ms
 1:  10.0.0.2                                              0.294ms
 2:  10.20.0.1                                             0.818ms reached
     Resume: pmtu 1500 hops 2 back 2
```

А теперь проверим в обратную сторону:
```
[root@ro3 ~]# tracepath 10.10.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.10.0.1                                             0.383ms reached
 1:  10.10.0.1                                             0.375ms reached
     Resume: pmtu 1500 hops 1 back 1
```
Видим, что в обратную сторону на 1 хоп меньше.

Чтобы сделать симметричный роутинг пропишем аналогичную стоимость линка на ro3:
```
!
interface eth2
 description to_ro2
 ip address 10.10.0.2/30
 ip ospf cost 20
 ip ospf dead-interval 10
 ip ospf hello-interval 5
 ip ospf mtu-ignore
 ip ospf network point-to-point
 ipv6 nd suppress-ra
!

```

Проверим количество хопов теперь:
```
[root@ro1 ~]# tracepath 10.20.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.0.0.2                                              0.324ms
 1:  10.0.0.2                                              0.524ms
 2:  10.20.0.1                                             1.055ms reached
     Resume: pmtu 1500 hops 2 back 2


[root@ro3 ~]# tracepath 10.0.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.20.0.2                                             1.318ms
 1:  10.20.0.2                                             1.360ms
 2:  10.0.0.1                                              1.797ms reached
     Resume: pmtu 1500 hops 2 back 2

```
