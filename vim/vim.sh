#!/bin/bash
cd ~
mkdir -p ~/.vim/{autoload,bundle,doc,plugin,doc}

cd ~/.vim/autoload
wget -O https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
cd ..

cd bundle
git clone https://github.com/davidhalter/jedi-vim.git
cd jedi-vim
git submodule update --init
cd ..

git clone https://github.com/scrooloose/nerdcommenter.git

git clone https://github.com/scrooloose/nerdtree.git

git clone https://github.com/scrooloose/syntastic.git
