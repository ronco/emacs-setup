;; EMBER SPECIFIC STUFF

;; disable lock files because broccoli
(setq create-lockfiles nil)

;; cleanup functions


(defun wrap-text (b e pretext posttext)
  "simple wrapper"
  (interactive "r\nMEnter text to prefix with: \nMEnter text to suffix with: ")
  (save-restriction
    (narrow-to-region b e)
    (goto-char (point-min))
    (insert pretext)
    (insert "\n")
    (goto-char (point-max))
    (insert posttext)
    )
  )

(defun wrap-jscs-disble (b e rule)
  "wrap region in a disabled jscs rule"
  (interactive "r\nMEnter the rule to disable: ")
  (let (
        (pretext (concat "// jscs: disable " rule))
        (posttext (concat "// jscs: enable " rule "\n"))
        )
    (wrap-text b e pretext posttext)
    )
  )
