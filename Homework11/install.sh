#!/bin/bash

yum install -y epel-release
yum install -y pam_script
useradd Administrator
groupadd admin
usermod -a -G admin Administrator
useradd User
usergroup -a -G users User
echo "Administrator:Otus" | chpasswd
echo "User:Otus" | chpasswd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i "2i auth  required  pam_script.so"  /etc/pam.d/sshd
cat <<'EOT' > /etc/pam_script
#!/bin/bash
if [[ `grep $PAM_USER /etc/group | grep 'admin'` ]]
then
exit 0
fi
if [[ `date +%u` > 5 ]]
then
exit 1
fi
EOT
chmod +x /etc/pam_script
systemctl restart sshd
