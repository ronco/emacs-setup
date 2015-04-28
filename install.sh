#!/bin/bash

emacs_setup_dir=`pwd`

echo "Creating $HOME/.emacs.d (if needed)"
mkdir -p $HOME/.emacs.d

echo "Creating $HOME/.emacs.d/emacs-setup as link to $emacs_setup_dir"
ln -s $emacs_setup_dir $HOME/.emacs.d/emacs-setup

echo "Creating $HOME/.emacs.d/init.el"
BREW_PREFIX=$(brew --prefix)
CASK_VERSION=$(cask --version)
CASK_DIR="${BREW_PREFIX}/Cellar/cask/${CASK_VERSION}/"
echo "(setq ronco-cask-dir \"${CASK_DIR}\")" > init.el.tmp
cat init.el >> init.el.tmp
mv init.el.tmp $HOME/.emacs.d/init.el

echo "Creating $HOME/.emacs.d/Cask"
ln -s $emacs_setup_dir/Cask $HOME/.emacs.d/Cask

pushd $HOME/.emacs.d
echo "Installing Packages with Cask"
cask install
popd
