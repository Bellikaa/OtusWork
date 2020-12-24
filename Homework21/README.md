# LDAP. Установка FreeIPA

1. Установить FreeIPA
2. Написать playbook для конфигурации клиента

В папке /roles находятся роли для настройки сервера FreeIPA, а также клиента для тестирования.
1. При выполнение `vagrant up` происходит автоматическая конфигурация сервера и клиента. 
2. Для проверки создадим ldap пользователя:
```
ipa user-add --first="Aleksandra" --last="Belyaeva" --cn="Aleksandra Belyeva" --shell="/bin/bash" --password
``` 
Видим, что пользовтель успешно создан:
```
[vagrant@ipaserver ~]$ ipa user-add --first="Aleksandra" --last="Belyaeva" --cn="Aleksandra Belyeva" --shell="/bin/bash" --password
User login [abelyaeva]:
Password:
Enter Password again to verify:
----------------------
Added user "abelyaeva"
----------------------
  User login: abelyaeva
  First name: Aleksandra
  Last name: Belyaeva
  Full name: Aleksandra Belyeva
  Display name: Aleksandra Belyaeva
  Initials: AB
  Home directory: /home/abelyaeva
  GECOS: Aleksandra Belyaeva
  Login shell: /bin/bash
  Principal name: abelyaeva@HOME.LOCAL
  Principal alias: abelyaeva@HOME.LOCAL
  User password expiration: 20201224102412Z
  Email address: abelyaeva@home.local
  UID: 275600005
  GID: 275600005
  Password: True
  Member of groups: ipausers
  Kerberos keys available: True

```
При первом входе пользователю будет предложено сменить пароль.

Пробуем войти в систему на клиенте под данным пользователем:
```
[vagrant@client ~]$ su -l abelyaeva
Password:
Password expired. Change your password now.
Current Password:
New password:
Retype new password:
Last login: Thu Dec 24 10:15:30 UTC 2020 on pts/0
-sh-4.2$
-sh-4.2$

```

Вход успешно выполнен. 
