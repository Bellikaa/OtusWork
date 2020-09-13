#!/bin/bash

cp /vagrant/logwatch.sh /opt/
cp /vagrant/logwatch.service /etc/systemd/system/
cp /vagrant/logwatch.timer /etc/systemd/system/
cp /vagrant/logwatch.log /var/log/
cp /vagrant/logwatch /etc/sysconfig/
systemctl daemon-reload
systemctl enable logwatch.service
systemctl enable logwatch.timer
systemctl start logwatch.timer

