#!/bin/bash

<<END
* This file will contain required configurations to setup the whole server...
END

if [[ "$UID" -eq "0" ]];
then
	echo -e "[-] Installing dependencies\n"
	apt install -y python3-pip docker vim

	echo -e "[-] Setting SETUID capability for python3\n"
	PYTHON=$(which python3)
	setcap "cap_setuid+ep" $PYTHON
	
	# Add the changes to a file and then remove this block
	echo -e "[-] Configuring sudoers file\n"
	echo -e '# BAU project :'>> /etc/sudoers
	echo '%Administrators	ALL=(ALL:ALL) ALL' >> /etc/sudoers
	echo 'Khaled ALL=(root) NOPASSWD: /usr/bin/vim' >> /etc/sudoers
	#echo 'Nabil ALL=(root) NOPASSWD: /usr/bin/docker' >> /etc/sudoers
	
	echo -e "[-] Creating a Crontab (tar *)\n"
	echo '* * * * * root /usr/bin/tar cvf Backup.tar /home/*' >> /etc/crontab

	echo -e "[-] Creating Users and configuring them\n"
	chmod +x /scripts/config_users.py 
	python3 /scripts/config_users.py
	
	echo -e "\n[-] Changing Computer name\n"
	echo "BAU-Project" > /etc/hostname
	
	
else
	echo "[!] Root privileges required"
fi
