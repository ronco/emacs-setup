;; EMBER SPECIFIC STUFF

;; disable lock files because broccoli
(setq create-lockfiles nil)

(add-hook 'js2-mode-hook
      (lambda ()
        (when (string-match-p "tests" (buffer-file-name))
          (setq js2-additional-externs '("document" "window" "location" "setTimeout" "$" "-Promise" "define" "console" "DS" "sandbox" "describe" "beforeEach" "afterEach" "before" "after"))
          )))
