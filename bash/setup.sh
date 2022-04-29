#!/usr/bin/env bash

git config --global user.name "Márton Torner"
git config --global user.email torner.marton@gmail.com
git config --global pull.ff only
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.st status
git config --global alias.hist "log --pretty=format:'%C(yellow)[%ad]%C(reset) %C(green)[%h]%C(reset) | %C(red)%s %C(bold red){{%an}}%C(reset) %C(blue)%d%C(reset)' --graph --date=short"

