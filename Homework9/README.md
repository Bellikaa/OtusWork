# Инициализация системы. Systemd.
# 1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл лога и ключевое слово должны задаваться в ```/etc/sysconfig```


[Здесь](https://github.com/Bellikaa/OtusWork/tree/master/Homework9/Task1) файлы Vagrant, скрипты и конфиг-файлы.
Можно проверить, что сервис работает командой
```systemctl status logwatch```
Скриншот, что все работает
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework9/Task1/picture1.png)

# 2. Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi);

[Здесь](https://github.com/Bellikaa/OtusWork/tree/master/Homework9/Task2) файлы Vagrant, скрипты и конфиг-файлы.
Можно проверить, что сервис работает командой
```systemctl status spawn-fcgi ```
Скриншот, что все работает
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework9/Task2/picture2.png)

# 3. Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами;

[Здесь](https://github.com/Bellikaa/OtusWork/tree/master/Homework9/Task3) файлы Vagrant, скрипты и конфиг-файлы.

Проверить можно командами:
```
systemctl status httpd@httpd1.service
systemctl status httpd@httpd2.service
```
Скриншот, что все работает
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework9/Task3/picture3.png)
