(defun ibotta-coffee-mode-hook ()
  "Hooks for coffee"
  (setq-local flycheck-coffeelintrc "coffeelint.json")
  (local-set-key "\C-c\C-c" #'coffee-compile-file)
  )
(add-hook 'coffee-mode-hook 'ibotta-coffee-mode-hook)
(customize-set-variable 'coffee-command "/Users/ronco/bin/black-coffee.sh")
