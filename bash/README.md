# Bash utils

## Install system requirements
```bash
curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/requirements/system.txt | grep -vE '^#' | xargs sudo apt install -yq
```

## Install toolkit

```bash
bash <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/install.sh) > .toolkit
```

```bash
echo ". ~/.toolkit" >> ~/.bashrc
# OR
echo ". ~/.toolkit" >> ~/.bash_profile
```

## Configure git
```bash
bash <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/configure/git.sh | grep -vE '^#')
```

## Install Powerline

```bash
curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/requirements/powerline.txt | grep -vE '^#' | xargs pip3 install
```

## Create a figlet banner

See example in banner.sh
```bash
sudo apt install -yq figlet
printf "WELCOME\nMR.TORNER" | figlet -cWw $(tput cols) -f standard
```
