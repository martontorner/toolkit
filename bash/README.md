# Bash utils

Install requirements:
```bash
grep -vE '^#' requirements.txt | xargs sudo apt install -yq
```

Install toolkit:
```bash
echo ". ~/git/toolkit/bash/include.sh" >> ~/.bashrc
# OR
echo ". ~/git/toolkit/bash/include.sh" >> ~/.bash_profile
```

Configure git:
```bash
./setup.sh
```

## Figlet banner

See example in banner.txt
```bash
sudo apt install -yq figlet
printf "WELCOME\nMR.TORNER" | figlet -cWw $(tput cols) -f standard
```

## Powerline

```bash
pip3 install powerline-status powerline-gitstatus
```
