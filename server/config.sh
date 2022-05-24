#!/bin/bash

<<END
* This file will contain required configurations to setup the whole server...
END

SERVER='/.Setup-Project/server'
WEBSERVER='/.Setup-Project/webserver'

if [[ "$UID" -eq "0" ]];
then
	echo "[-] Installing dependencies"
	apt update -y && apt upgrade -y
	apt install  -y php libapache2-mod-php php-mysql
	apt update -y
	apt install -y whois mysql-server apache2 python3-pip docker.io docker-compose vim ssh net-tools gdb php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip tmux

	# Firewall rules and things
	echo -e "\n[-] Setting up firewall rules and ssh"
	ufw --force enable
	ufw allow "Apache Full"
	ufw allow "OpenSSH"
	service sshd start
	ssh-keygen -t rsa -N 'Mohammad_threats2022!' -f /root/.ssh/id_rsa <<< y
	service apache2 start

	# Setting up apache2 server
	echo -e "\n[-] Setting up apache2 and wordpress"
	echo "127.0.0.1 threats.int" >> /etc/hosts
	cp $WEBSERVER/apache-selfsigned.key /etc/ssl/private/
	cp $WEBSERVER/apache-selfsigned.crt /etc/ssl/certs/
	cp -r $WEBSERVER/threats.int /var/www/
	cp $WEBSERVER/apache2.conf /etc/apache2/
	cp $WEBSERVER/threats.int.conf /etc/apache2/sites-available/
	cp $WEBSERVER/default-ssl.conf /etc/apache2/sites-available/
	cp $WEBSERVER/ssl-params.conf /etc/apache2/conf-available/
	a2ensite threats.int.conf
	a2dissite 000-default.conf
	a2enmod rewrite
	a2enmod ssl
	a2enmod headers
	a2ensite default-ssl
	a2enconf ssl-params
	chown -R www-data:www-data /var/www/threats.int
	find /var/www/threats.int/ -type d -exec chmod 750 {} \;
	find /var/www/threats.int/ -type f -exec chmod 640 {} \;
	chmod 775 -R /var/log/apache2 
	systemctl restart apache2

	# Configuring Mysql database
	echo -e "\n[-] Configuring Mysql"
	mysql -e "CREATE USER 'mohammad'@'localhost' IDENTIFIED BY 'Mohammad_threats2022!';"
	mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'mohammad'@'localhost';"
	mysql -e "FLUSH PRIVILEGES;"
	mysql -e 'CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;'
	mysql wordpress < $WEBSERVER/wordpress.sql

	# Creating users and groups
	echo -e "\n[-] Creating Users and configuring them"
	# Below line will fix home folder creation issue..
	echo "CREATE_HOME yes" >> /etc/login.defs
	groupadd admin
	groupadd forensic_department
	groupadd developers
	usermod --password `mkpasswd 'Mohammad_threats2022!'` root
	useradd -d /home/mohammad -p `mkpasswd 'Mohammad_threats2022!'` mohammad -G admin -s /bin/bash -m
	useradd -d /home/moayad -p `mkpasswd 'Moayad_threats2022!'` moayad -G adm -s /bin/bash -m
	useradd -d /home/zeyad -p `mkpasswd 'Zeyad_threats2022!'` zeyad -G forensic_department -s /bin/bash -m
	useradd -d /home/omar -p `mkpasswd 'Omar_threats2022!'` omar -G forensic_department -s /bin/bash -m
	useradd -d /home/khaled -p `mkpasswd 'Khaled_threats2022!'` khaled -G developers -s /bin/bash -m
	useradd -d /home/baker -p `mkpasswd 'Baker_threats2022!'` baker -G developers -s /bin/bash -m
	useradd -d /home/nabil -p `mkpasswd 'Nabil_threats2022!'` nabil -G developers,docker -s /bin/bash -m
	su -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y" zeyad
	su -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y" omar
	su -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y" nabil
	su -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y" baker
	cp $SERVER/sudoers /etc/sudoers
	echo "[+] Congratulations on Successfully Hacking this Server!" > /root/proof.txt

	# Running tar every minute
  echo -e "\n[-] Creating a Crontab (tar *)"
	cp $SERVER/backup.sh /usr/bin/backup
	chown root:developers /usr/bin/backup
	chmod g+rx /usr/bin/backup
  echo  "*  *  * * * baker /usr/bin/backup" >> /etc/crontab
	echo "" >> /etc/crontab
  echo baker > /etc/cron.allow
	chown -R www-data:developers /var/www/threats.int/


	
	echo -e "\n[-] Giving [developers] group a permission to manage services"
	cp $SERVER/debug.service /etc/systemd/system/debug.service
	chown root:developers /etc/systemd/system/debug.service
	chmod g+rw /etc/systemd/system/debug.service
	cp $SERVER/restart_services /usr/bin/restart_services

	echo -e "\n[-] Changing Computer name to: BAU-Project"
	echo "BAU-Project" > /etc/hostname

	echo -e "\nMachine IP -->" `hostname -I | cut -d' ' -f2` 2>/dev/null
	
else
	echo "[!] Root privileges required"
fi
