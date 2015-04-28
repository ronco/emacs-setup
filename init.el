(require 'cask (concat ronco-cask-dir "cask.el"))
(cask-initialize)
(require 'pallet)
(load (concat user-emacs-directory "emacs-setup/emacs-setup.el"))
