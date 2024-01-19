# Bash Toolkit

## Install system requirements
```bash
curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/shell/requirements/system.txt | grep -vE '^#' | xargs sudo apt install -yq
```

## Install toolkit

```bash
zsh <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/install.sh) > ~/.toolkitrc
```

```bash
echo ". ~/.toolkitrc" >> ~/.zshrc
```

## Configure git
```bash
zsh <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/configure/git.sh | grep -vE '^#')
```

## Install Powerline

```bash
curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/requirements/powerline.txt | grep -vE '^#' | xargs pip3 install
zsh <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/configure/powerline.sh | grep -vE '^#')
```
