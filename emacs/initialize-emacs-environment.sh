#!/bin/bash

# initialize emacs environment for init.el to run properly
# see init.org/emacs-install for more info

# cd $HOME
# mkdir org
# echo '#+TITLE: todo.org\n' > todo.org
# echo '#+TITLE: notes.org\n' > notes.org

EMACS_HOME="/home/gloftus/.emacs.d/"
cd $EMACS_HOME

mkdir elisp themes
touch elisp/customize.el elisp/local-config.el

curl https://raw.githubusercontent.com/emacsfodder/emacs-mustard-theme/master/mustard-theme.el -o themes/mustard-theme.el

