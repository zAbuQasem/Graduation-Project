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
	apt install -y whois mysql-server apache2 python3-pip docker.io vim ssh net-tools gdb php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

	echo -e "\n[-] Setting up firewall rules and ssh"
	ufw --force enable
	ufw allow "Apache Full"
	ufw allow "OpenSSH"
	service sshd start
	ssh-keygen -t rsa -N 'Mohammad_threats2022!' -f /root/.ssh/id_rsa <<< y
	service apache2 start

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


	echo -e "\n[-] Configuring Mysql"
	mysql -e "CREATE USER 'mohammad'@'localhost' IDENTIFIED BY 'Mohammad_threatsint2022!';"
	mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'mohammad'@'localhost';"
	mysql -e "FLUSH PRIVILEGES;"
	mysql -e 'CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;'
	mysql wordpress < $WEBSERVER/wordpress.sql

	echo -e "\n[-] Setting SETUID capability for python3"
	PYTHON=$(ls -la /usr/bin/python3 | cut -d ">" -f 2 | cut -d " " -f 2)
	setcap "cap_setuid+ep" /usr/bin/$PYTHON
	
	echo -e "\n[-] Compiling PackageDownloader and giving Setuid -> /usr/bin/PackageDownloader"
	gcc $SERVER/PackageDownloader.c -o $SERVER/PackageDownloader
        cp $SERVER/PackageDownloader /usr/bin/
        chmod +s /usr/bin/PackageDownloader

	echo -e "\n[-] Creating a Crontab (tar *)"
	echo '* * * * * root /bin/tar cvf /var/backups/Backup.tar /var/www/*' >> /etc/crontab
	echo '* * * * * root /bin/echo > /var/log/apache2/access.log' >> /etc/crontab

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
	cp $SERVER/sudoers /etc/sudoers
	cp -r $SERVER/Live-Cases /opt/
	chown mohammad:forensic_department /opt/Live-Cases
	chmod 750 /opt/Live-Cases
	ln -s /opt/Live-Cases /home/omar/Live-Cases
	ln -s /opt/Live-Cases /home/zeyad/Live-Cases

	echo -e "\n[-] Giving [developers] group a permission to manage services"
	echo -e "# Currently we are using this file for debugging purposes..\n[Service]\nType=simple\nUser=root\nExecStart=/usr/bin/whoami\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/debug.service
	chown root:developers /etc/systemd/system/debug.service
	chmod g+rw /etc/systemd/system/debug.service

	echo -e "\n[-] Changing Computer name to: BAU-Project"
	echo "BAU-Project" > /etc/hostname

	echo -e "\nMachine IP -->" `hostname -I | cut -d' ' -f2` 2>/dev/null
	
else
	echo "[!] Root privileges required"
fi

