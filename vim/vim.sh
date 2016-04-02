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
    cd jedi-vim
    git pull
else
    git clone --recursive https://github.com/davidhalter/jedi-vim.git
fi

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

cd ~/.vim/bundle
if [ -d 'indentLine' ]; then
    cd indentLine
    git pull
else
    git clone https://github.com/Yggdroot/indentLine.git
fi

curl -sL 'http://www.vim.org/scripts/download_script.php?src_id=19574' -o /tmp/taglist.zip
unzip -o /tmp/taglist.zip -d ~/.vim
rm /tmp/taglist.zip
