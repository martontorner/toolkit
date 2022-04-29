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
