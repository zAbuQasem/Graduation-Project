# Vulnerable Linux Server
As a CTF players and infosec geeks we decided to make this server as our graduation project!
## What will you learn?
1. Exploit LFI to read arbitary files.
2. Take advantage of weak password policies.
3. Exploiting a wildcard injection.
4. Systemd services.
5. Docker containers and mounts.

## Setting up the environment
```bash
wget https://github.com/zAbuQasem/Graduation-Project/releases/download/1.0/Project.tar.gz
tar -zxvf Project.tar.gz
cd Bau-Project
sudo vagrant up

# Get the Machine ip
sudo vagrant ssh
<Inside vm> ifconfig

# Then add the ip, domain to /etc/hosts
sudo vim /etc/hosts
<ip> threats.int
```

# Demonstration Video:
[<img src="https://i.ytimg.com/vi/oYMAUlkPkT4/maxresdefault.jpg" width="50%">](https://www.youtube.com/watch?v=oYMAUlkPkT4 "Demonstration Video")

## References
- [Vagrant docs](https://www.vagrantup.com/docs)
- [LFI-Tutorial](https://brightsec.com/blog/local-file-inclusion-lfi/)
- [Systemd Services](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [Docker run](https://docs.docker.com/engine/reference/run/)
