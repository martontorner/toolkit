# Bash utils

Install requirements:
```bash
grep -vE '^#' requirements.txt | xargs sudo apt install -yq
```

In .bashrc or .bash_profile:
```bash
. ~/git/toolkit/bash/include.sh
```

## Figlet banner

See example in banner.txt
```bash
printf "WELCOME\nMR.TORNER" | figlet -cWw $(tput cols) -f standard
```

## Powerline

```bash
pip3 install powerline-status powerline-gitstatus
```

## Git

```bash
git config --global user.name "Márton Torner"
git config --global user.email torner.marton@gmail.com
git config --global pull.ff only
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.st status
git config --global alias.hist=log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short
```
