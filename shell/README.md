# Shell Toolkit

Core for all cli toolkits

## Create a figlet banner

See example in banner.sh
```bash
sudo apt install -yq figlet
printf "WELCOME\nMR.TORNER" | figlet -cWw $(tput cols) -f standard
```
