#!/bin/bash
# This script downloads my collected bundles and plugins for vim.
# Support all Unix OSes.
# License: MIT
SCRIPT_LOCATION=`cd $(dirname $0); pwd`
cp $SCRIPT_LOCATION/.vimrc ~
cd ~
mkdir -p ~/.vim/{autoload,bundle,doc,plugin,doc}

cd ~/.vim/autoload
curl -O https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle
if [ -d 'jedi-vim' ]; then
    rm -rf jedi-vim
    git clone --recursive https://github.com/davidhalter/jedi-vim.git
else
    git clone --recursive https://github.com/davidhalter/jedi-vim.git
fi

cd ~/.vim/bundle

if [ -d 'nerdcommenter' ]; then
    cd nerdcommenter
    git stash
    git stash drop
    git pull
else
    git clone https://github.com/scrooloose/nerdcommenter.git
fi

cd ~/.vim/bundle
if [ -d 'nerdtree' ]; then
    cd nerdcommenter
    git stash
    git stash drop
    git pull
else
    git clone https://github.com/scrooloose/nerdtree.git
fi

cd ~/.vim/bundle
if [ -d 'syntastic' ]; then
    cd syntastic
    git stash
    git stash drop
    git pull
else
    git clone https://github.com/scrooloose/syntastic.git
fi

cd ~/.vim/bundle
if [ -d 'indentLine' ]; then
    cd indentLine
    git stash
    git stash drop
    git pull
else
    git clone https://github.com/Yggdroot/indentLine.git
fi

cd ~/.vim/bundle
if [ -d 'javacomplete' ]; then
    cd javacomplete
    git stash
    git stash drop
    git pull
else
    git clone https://github.com/vim-scripts/javacomplete.git
fi

cd ~/.vim/bundle
if [ -d 'ctrlp' ]; then
    cd ctrlp
    git stash
    git stash drop
    git pull
else
    git clone https://github.com/ctrlpvim/ctrlp.vim.git ctrlp
fi

cd ~/.vim/
mkdir -p {doc,plugin}

wget https://github.com/vim-scripts/taglist.vim/raw/master/doc/taglist.txt -O ~/.vim/doc/taglist.txt

wget https://github.com/vim-scripts/taglist.vim/raw/master/plugin/taglist.vim -O ~/.vim/plugin/taglist.vim
