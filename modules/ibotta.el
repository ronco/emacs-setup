(defun ibotta-coffee-mode-hook ()
  "Hooks for coffee"
  (setq-local flycheck-coffeelintrc "coffeelint.json")
  (local-set-key "\C-c\C-c" #'coffee-compile-file)
  )
(add-hook 'coffee-mode-hook 'ibotta-coffee-mode-hook)
(customize-set-variable 'coffee-command "/Users/ronco/bin/black-coffee.sh")

(defun dev-db ()
  (interactive)
  (ronco-sql-connect 'mysql 'dev))

(defun staging-db ()
  (interactive)
  (ronco-sql-connect 'mysql 'staging))

(defun reporting-db ()
  (interactive)
  (ronco-sql-connect 'mysql 'reporting))

(defun ronco-sql-connect (product connection)
  (require 'ib-sql "ib-sql.el.gpg")
  (setq sql-product product)
  (sql-connect connection))
