# Bash Toolkit

## Install system requirements
```bash
curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/shell/requirements/system.txt | grep -vE '^#' | xargs sudo apt install -yq
```

## Install toolkit

```bash
zsh <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/zsh/install.sh) > ~/.toolkitrc
```

```bash
echo ". ~/.toolkitrc" >> ~/.zshrc
```

## Configure git

Generate GPG key
```shell
gpg --full-generate-key
```

Update environment and user specific configs
```shell
git config --global user.name "Márton Torner"
git config --global user.email torner.marton@gmail.com
git config --global user.signingkey <ID>
```

Update common configs
```bash
bash <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/shell/configure/git.sh | grep -vE '^#')
```

## Install Powerline

```bash
curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/shell/requirements/powerline.txt | grep -vE '^#' | xargs pip3 install
zsh <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/shell/configure/powerline.sh | grep -vE '^#')
```
