#!/bin/sh

sudo apt-get remove --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common
brew uninstall vim
brew install luajit
brew install vim --with-luajit
