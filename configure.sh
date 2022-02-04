#!/bin/bash

<<END
* This file will contain required configurations to setup the whole server...
END

if [[ "$UID" -eq "0" ]];
then
	echo -e "[-] Installing dependencies\n"
	apt install -y python3-pip docker vim

	echo -e "[-] Setting SETUID capability for python3\n"
	setcap "cap_setuid+ep" /usr/bin/python3.8

	echo -e "[-] Configuring sudoers file\n"
	echo -e '\n# BAU project :'>> /etc/sudoers
	echo '%Administrators	ALL=(ALL:ALL) ALL' >> /etc/sudoers
	echo 'Khaled ALL=(root) NOPASSWD: /usr/bin/vi' >> /etc/sudoers

	echo -e "Creating Users and configuring them\n"
	chmod +x /scripts/config_users.py 
	python3 /scripts/config_users.py
else
	echo "[!] Root privileges required"
fi