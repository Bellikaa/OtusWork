
# Первые шаги с Ansible.
# Домашнее задание. Подготовительный этап.

Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере используя Ansible необходимо развернуть nginx со следующими условиями:  
- необходимо использовать модуль yum/apt  
- конфигурационные файлы должны быть взяты из шаблона jinja2 с перемененными  
- после установки nginx должен быть в режиме enabled в systemd  
- должен быть использован notify для старта nginx после установки  
- сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible

**Проверим ssh конфиг и создадим inventory файл, после проверим, что Ansible может управлять нашим хостом**
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework10/pic/pic1.png)

Видим что пинг проходит успешно.

**Для начала воспользуемся Ad-Hoc командами и выполним некоторые удаленные команды на нашем хосте.**
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework10/pic/pic2.png)

**Установим пакет epel-release на наш хост**
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework10/pic/pic3.png)

**Теперь удалим пакет и заново установим его при помощи playbook'а**
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework10/pic/pic4.png)

# Основной этап.

**Проверим имеющиеся теги командой `ansible-playbook nginx.yml --list-tags` и запустим установку только nginx командой `ansible-playbook nginx.yml -t nginx-package`**
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework10/pic/pic5.png)

**Далее добавим шаблон для конфига NGINX и модуль, который будет копировать этот шаблон на хост и необходимую переменную и проверим:**

Сам шаблон выглядит так: 

  ```
  events { 
   worker_connections 1024;
  }

  http { 
   server { 
     listen {{ nginx_listen_port }} default_server; 
     server_name default_server; 
     root /usr/share/nginx/html; 
     location / {
      } 
   }
 }
  ```
**Теперь создадим handler и добавим notify к копированию шаблона. Теперь каждый раз когда конфиг будет изменяться - сервис перезагрузится.**
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework10/pic/pic6.png)

**Убедимся, что сайт доступен:**
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework10/pic/pic7.png)

# Переведем в роль и проверим
![Image](https://github.com/Bellikaa/OtusWork/blob/master/Homework10/pic/pic8.png)

[Файлы роли здесь](https://github.com/Bellikaa/OtusWork/tree/master/Homework10/Ansible/nginx_role/nginx) 
