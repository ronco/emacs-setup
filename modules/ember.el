;; EMBER SPECIFIC STUFF

;; disable lock files because broccoli
(setq create-lockfiles nil)

;; add mocha test specific globals
(add-hook 'js2-init-hook
          (lambda ()
        (when (string-match-p "test" (buffer-file-name))
          (setq js2-additional-externs '("document" "window" "location" "setTimeout" "$" "-Promise" "define" "console" "DS" "sandbox" "describe" "beforeEach" "afterEach" "before" "after"))
          )))
