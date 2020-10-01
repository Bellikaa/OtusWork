# Пользователи и группы. Авторизация и аутентификация
-----------------------------------------------------------------------
### Домашнее задание. PAM.
	1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников
#### Способ с редактированием файла ```/etc/security/time.conf``` не работает с группами, поэтому будем использовать вариант с модулем pam_script.
- Создаем группу ```groupadd admin```
- Добавляем туда пользователя ```usermod -aG admin Administrator```
- Добавляем также обычного пользователя User, который не будет входить в группу admin
- Устанавливаем компонент, с помощью которого мы сможем описывать правила входа в виде обычного bash скрипта ```yum install pam_script -y```
- Приводим файл ```/etc/pam.d/sshd``` к следующему виду и добавляем строку ```auth       required     pam_script.so```:
```
#%PAM-1.0
auth       required     pam_sepermit.so
auth       substack     password-auth
auth       required     pam_script.so   
auth       include      postlogin
# Used with polkit to reauthorize users in remote sessions
-auth      optional     pam_reauthorize.so prepare
account    required     pam_nologin.so
account    required     pam_access.so
account    required     pam_time.so
account    include      password-auth
password   include      password-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    required     pam_loginuid.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open env_params
session    required     pam_namespace.so
session    optional     pam_keyinit.so force revoke
session    include      password-auth
session    include      postlogin
# Used with polkit to reauthorize users in remote sessions
-session   optional     pam_reauthorize.so prepare
```
- Далее приводим файл ```/etc/pam_script``` к следующему виду: (у файла должны быть права на исполнение):

```
#!/bin/bash

if [[ `grep $PAM_USER /etc/group | grep 'admin'` ]]
then
exit 0
fi
if [[ `date +%u` > 5 ]]
then
exit 1
fi
```
Скрипт проверяет состоит ли пользователь в группе admin, если пользователь не состоит в группе, то срабатывает проверка дня недели, если день недели больше 5 (то есть выходной), то не пускает. 

Для проверки можно поменять дату на выходной день и проверить работу правила:
```
sudo date +%Y%m%d -s "20201003"
```
