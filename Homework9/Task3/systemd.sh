#!/bin/bash

setenforce 0
yum install -y httpd

cp /vagrant/httpd/httpd@.service /etc/systemd/system
cp /vagrant/httpd/tmp.conf /etc/httpd/conf.d/tmp.conf
cp /vagrant/httpd/httpd{1,2} /etc/sysconfig

systemctl enable --now httpd@httpd1.service
systemctl enable --now httpd@httpd2.service
