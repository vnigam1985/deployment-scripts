#!/bin/bash
# This script downloads my collected bundles and plugins for vim.
# Support all Unix OSes.
# License: MIT
SCRIPT_LOCATION=`cd $(dirname $0); pwd`
cp SCRIPT_LOCATION/.vimrc ~
cd ~
mkdir -p ~/.vim/{autoload,bundle,doc,plugin,doc}

cd ~/.vim/autoload
curl -O https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle
git clone https://github.com/davidhalter/jedi-vim.git
cd jedi-vim
git submodule update --init

cd ~/.vim/bundle

if [ -d 'nerdcommenter' ]; then
    cd nerdcommenter
    git pull
else
    git clone https://github.com/scrooloose/nerdcommenter.git
fi

cd ~/.vim/bundle
if [ -d 'nerdtree' ]; then
    cd nerdcommenter
    git pull
else
    git clone https://github.com/scrooloose/nerdtree.git
fi

cd ~/.vim/bundle
if [ -d 'syntastic' ]; then
    cd syntastic
    git pull
else
    git clone https://github.com/scrooloose/syntastic.git
fi

