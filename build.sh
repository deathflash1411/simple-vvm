#!/bin/bash

# simple-vvm by @deathflash1411

if [[ $EUID > 0 ]]
  then echo "[!] Script must be run as root"
  exit
fi

echo -e "\n[+] Updating packages"
apt update && apt upgrade -y

echo -e "\n[+] Installing packages"
apt install -y net-tools open-vm-tools unzip apache2 php php-curl php-gd php-zip php-xml

echo -e "\n[+] Downloading cms"
wget http://get-simple.info/data/uploads/releases/GetSimpleCMS-3.3.16.zip -O /root/GetSimpleCMS-3.3.16.zip

echo -e "\n[+] Configuring cms"
a2enmod rewrite
rm -rf /var/www/html/*
unzip /root/GetSimpleCMS-3.3.16.zip -d /var/www/html/
mv /var/www/html/GetSimpleCMS-3.3.16/* /var/www/html/
chown -R www-data:www-data /var/www/html/*


echo -e "\n[+] Creating users"
id -u simple &>/dev/null || useradd -m simple
usermod -a -G sudo simple

echo -e "\n[+] Restarting services"
systemctl enable apache2
systemctl restart apache2

echo -e "\n[+] Configuring firewall"
sed -i 's/IPV6=yes/IPV6=no/g' /etc/default/ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw enable
ufw status verbose

echo -e "\n[+] Disabling history"
ln -sf /dev/null /root/.bash_history
ln -sf /dev/null /home/simple/.bash_history

echo -e "\n[+] Changing passwords"
echo "root:ImNotThatSimple11" | chpasswd
echo "simple:simple1" | chpasswd

echo -e "\n[+] Creating flags"
echo "18af77e44d288b89923d03e1a189c249" > /root/proof.txt
echo "22f22750c3690cdf42b7d3b782d56de5" > /home/simple/local.txt
chmod 0400 /root/proof.txt
chown root:root /root/proof.txt
chmod 0444 /home/simple/local.txt
chown simple:simple /home/simple/local.txt

echo -e "\n[+] Changing hostname"
hostnamectl set-hostname simple
cat << EOF > /etc/hosts
127.0.0.1 localhost simple simple.pg
EOF

echo -e "\n[+] Cleaning up"
rm -rf /root/build.sh
rm -rf /root/.cache
rm -rf /root/GetSimpleCMS-3.3.16.zip
rm -rf /home/simple/.sudo_as_admin_successful
rm -rf /home/simple/.cache
find /var/log -type f -exec sh -c "cat /dev/null > {}" \;

echo -e "\n[+] Build successful"