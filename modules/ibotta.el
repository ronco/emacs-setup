(defun ibotta-coffee-mode-hook ()
  "Hooks for coffee"
  (setq-local flycheck-coffeelintrc "coffeelint.json")
  (local-set-key "\C-c\C-c" #'coffee-compile-file)
  (local-set-key "\C-c\C-d" #'decaffeinate)
  )
(add-hook 'coffee-mode-hook 'ibotta-coffee-mode-hook)
(customize-set-variable 'coffee-command "/Users/ronco/bin/black-coffee.sh")

(defun decaffeinate ()
  (interactive)
  (let ((coffee-command "/Users/ronco/bin/decaffeinate-coffee.sh"))
    (coffee-compile-file)
    )
  )

(defun dev-db ()
  (interactive)
  (ronco-sql-connect 'mysql 'dev))

(defun staging-db ()
  (interactive)
  (ronco-sql-connect 'mysql 'staging))

(defun reporting-db ()
  (interactive)
  (ronco-sql-connect 'mysql 'reporting))

(defun redshift-db ()
  (interactive)
  (ronco-sql-connect 'postgres 'redshift))

(defun ronco-sql-connect (product connection)
  (require 'ib-sql "ib-sql.el.gpg")
  (setq sql-product product)
  (sql-connect connection))


;; tramp
(require 'tramp)
(add-to-list 'tramp-default-proxies-alist
             '("webapp-server-staging-a01\\.ibotta\\.com\\'"
               "\\`ibotta\\'"
               "/ssh:ubuntu@%h:"))
