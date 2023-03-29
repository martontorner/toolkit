#!/usr/bin/env bash

git config --global user.name "Márton Torner"
git config --global user.email torner.marton@gmail.com
git config --global pull.ff only
git config --global core.excludesfile ~/.gitignore
git config --global advice.addEmptyPathspec false

git config --global alias.unstage "reset"

git config --global init.defaultbranch master
git config --global core.editor vim
