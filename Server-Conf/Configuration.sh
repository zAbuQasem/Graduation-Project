#!/bin/bash

<<END
* This file will contain required configurations to setup the whole server...
END

if [[ "$UID" -eq "0" ]];
then
	echo -e "[-] Installing dependencies\n"
	apt update -y && apt upgrade -y
	apt install -y apache2 python3-pip docker vim ssh net-tools 

	echo -e "[-] Setting SETUID capability for python3\n"
	PYTHON=$(which python3)
	setcap "cap_setuid+ep" $PYTHON
	
	echo -e "[-] Creating a Crontab (tar *)\n"
	echo '* * * * * root /usr/bin/tar cvf /var/backups/Backup.tar /var/www/html/*' >> /etc/crontab

	echo -e "[-] Creating Users and configuring them\n"
	chmod +x ./create_users.py 
	python3 ./create_users.py
	
	echo -e "\n[-] Changing Computer name\n"
	echo "BAU-Project" > /etc/hostname
	
	
else
	echo "[!] Root privileges required"
fi
