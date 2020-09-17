#!/bin/bash

setenforce 0
yum install -y httpd

cp /vagrant/httpd/httpd@httpd{1,2}.service /usr/lib/systemd/system/
cp /vagrant/httpd/httpd{1,2}.conf /etc/httpd/

systemctl enable --now httpd@httpd1.service
systemctl enable --now httpd@httpd2.service
