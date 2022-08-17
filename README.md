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
```
## References
- [Vagrant docs](https://www.vagrantup.com/docs)
- [LFI-Tutorial](https://brightsec.com/blog/local-file-inclusion-lfi/)
- [Systemd Services](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [Docker run](https://docs.docker.com/engine/reference/run/)
