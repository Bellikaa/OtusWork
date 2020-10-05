# Практика с SELinux.
# 1. Запустить nginx на нестандартном порту 3-мя разными способами:  
- переключатели setsebool;  
- добавление нестандартного порта в имеющийся тип;  
- формирование и установка модуля SELinux.
1. Установим nginx, поменяем порт в конфиге на отличный от стандартного (скрин конфига)

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/otus-linux-adm/selinux_dns_problems/pic/pic1.png)

Проверим, что сервис не запускается с таким портом:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/otus-linux-adm/selinux_dns_problems/pic/pic2.png)

2. Установим  пакет yum install setools-console.x86_64 и setroubleshoot, yum install -y setroubleshoot-server.x86_64

3. При помощи команды sealert  проверим возможные варианты решения проблемы и проверим каждый из них:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/otus-linux-adm/selinux_dns_problems/pic/pic3.png)

4. Сначала проверим при помощи команды setsebool. Проверим состояние параметра:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/otus-linux-adm/selinux_dns_problems/pic/pic4.png)

5. Изменим состояние параметра на on (1) и проверим запуск сервиса:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/otus-linux-adm/selinux_dns_problems/pic/pic5.png)Как видим сервис запустился.

**Теперь вернем параметр в исходное состояние и проверим другой вариант - добавление нестандартного порта в имеющийся тип.**

1. Проверим, что все вернули в исходное состояние:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/otus-linux-adm/selinux_dns_problems/pic/pic6.png)

2. Добавим порт в тип и проверим его в списке разрешенных портов для типа http_port_t:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/otus-linux-adm/selinux_dns_problems/pic/pic7.png)

Сервис запустился.

**Вернем параметр в исходное состояние и проверим другой вариант - формирование и установка собственного модуля SELinux.**

Удалим порт из типа:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/otus-linux-adm/selinux_dns_problems/pic/pic8.png)

Создадим свой модуль с помощью команд ausearch  и semodule:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/otus-linux-adm/selinux_dns_problems/pic/pic9.png)

Сервис запустился.

# Задание 2.

Проверим ошибки Selinux при помощи audit2why и audit2allow, для этого переведем SElinux  в статус Permissive  и проверим работает ли обновление зоны:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/otus-linux-adm/selinux_dns_problems/pic/pic10.png)

Потом по рекомендации добавим модуль и проверим с клиента работу с SElinux  в режиме enforcing:

![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework12/Task2/otus-linux-adm/selinux_dns_problems/pic/pic11.png)
