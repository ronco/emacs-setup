
(setq ronco-es/dir (concat
                    user-emacs-directory
                    "emacs-setup"))

;; pallet mode
(pallet-mode t)

;; path
;; add brew path
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; package
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;; shell
(setq explicit-bash-args '("--noediting" "--login"))

;; env setup
(setenv "NODENV_VERSION" "v0.12")
(setenv "RBENV_VERSION" "2.1.6")
(setenv "LANG" "en_US.UTF-8")

;; UTF-8
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)

;; os keys
;; allow right alt to enter funky characters
(setq ns-right-alternate-modifier nil)

;; start emacs server
(require 'server)
(if (server-running-p)
    (message "Server is running")
  (progn
    (message "Starting server")
    (server-start)))

;; save place
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; theme
(require 'moe-theme)
(moe-theme-random-color)
(moe-dark)

;; fonts
;;(dynamic-fonts-setup)
(if window-system
    (progn
      (set-face-attribute 'default nil :font "Menlo-12")
      (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") nil 'prepend)
      ))


;; mode line
(require 'powerline)
(powerline-moe-theme)

;; memory
(setq gc-cons-threshold 20000000)

;; info
(setq user-full-name "Ron White"
      user-mail-address "ronco@costite.com")

;; command invocation
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))

(global-set-key "\C-x\C-m" 'smex)

;; text size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; goto line
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

;; move lines
(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines -1))
    (move-to-column col)))
(global-set-key (kbd "<C-M-S-down>") 'move-line-down)
(global-set-key (kbd "<C-M-S-up>") 'move-line-up)

;; window resizing

(defun increase-window-height (&optional arg)
  "Make the window taller by one line. Useful when bound to a repeatable key combination."
  (interactive "p")
  (enlarge-window arg))

(defun decrease-window-height (&optional arg)
  "Make the window shorter by one line. Useful when bound to a repeatable key combination."
  (interactive "p")
  (enlarge-window (- 0 arg)))

(defun decrease-window-width (&optional arg)
  "Make the window narrower by one line. Useful when bound to a repeatable key combination."
  (interactive "p")
  (enlarge-window (- 0 arg) t))

(defun increase-window-width (&optional arg)
  "Make the window shorter by one line. Useful when bound to a repeatable key combination."
  (interactive "p")
  (enlarge-window arg t))

(global-set-key (kbd "C->")
                'increase-window-height)

(global-set-key (kbd "C-<")
                'decrease-window-height)

(global-set-key (kbd "C-,")
                'decrease-window-width)

(global-set-key (kbd "C-.")
                'increase-window-width)

(add-hook 'org-mode-hook
          (lambda ()
            (define-key org-mode-map [(ctrl \,)]
              'decrease-window-width)))


;; newline anywhere
(defun newline-anywhere ()
  "Add a newline from anywhere in the line."
  (interactive)
  (end-of-line)
  (newline-and-indent))

(global-set-key (kbd "M-RET")
                'newline-anywhere)

;; quiet down the display
;; visible-bell breaks center display on el-capitan
(setq visible-bell nil
      inhibit-startup-message t
      ring-bell-function 'ignore
)

;; (defun major-mode-from-name ()
;;   "Choose proper mode for buffers created by switch-to-buffer."
;;   (let ((buffer-file-name (or buffer-file-name (buffer-name))))
;;     (set-auto-mode)))
;; (setq-default major-mode 'major-mode-from-name)

;; whitespace
;; make whitespace-mode use just basic coloring
(setq whitespace-style (quote (trailing face)))
(defun turn-on-whitespace ()
  (whitespace-mode))
(add-hook 'prog-mode-hook 'turn-on-whitespace)

;; rectangles
(add-hook 'prog-mode-hook
          (lambda ()
            (local-set-key (kbd "C-<return>") #'cua-rectangle-mark-mode)
            ))


;; yes or no
(defalias 'yes-or-no-p 'y-or-n-p)

;; autofill

(defun esk-local-comment-auto-fill ()
  (set (make-local-variable 'comment-auto-fill-only-comments) t)
  (auto-fill-mode t))
(add-hook 'prog-mode-hook 'esk-local-comment-auto-fill)

(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; line & col numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; highlight current line
(defun esk-turn-on-hl-line-mode ()
  (when (> (display-color-cells) 8)
    (hl-line-mode t)))

(add-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)

;; lambda
(defun esk-pretty-lambdas ()
  (font-lock-add-keywords
   nil `(("(?\\(lambda\\>\\)"
          (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                    ,(make-char 'greek-iso8859-7 107))
                    nil))))))

(add-hook 'prog-mode-hook 'esk-pretty-lambdas)


;; tramp
(setq tramp-default-method "ssh")

;; behavioral stuff

(setq ns-pop-up-frames 'nil)

; code templates
(require 'yasnippet)
(eval-after-load "yasnippet"
  (lambda ()
    (dolist (yadir (list
                    yas-installed-snippets-dir
                    "/Users/ronco/github/ember-yasnippets.el/snippets"
                    "/Users/ronco/github/mocha-snippets.el/snippets"
                    (concat ronco-es/dir "/ib-snippets")
                    (concat ronco-es/dir "/snippets")
                    (concat ronco-es/dir "/yasnippet-snippets")))
      (add-to-list 'yas-snippet-dirs yadir)
      (yas-load-directory yadir)
      )
    ))

(yas-global-mode 1)

;; parens
(require 'smartparens-config)
(smartparens-global-mode)
(show-smartparens-global-mode +1)


;; xml format
(defun xml-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "xmllint --format -" (buffer-name) t)
  )
)

;; tabs & spaces
(defun 4x4-spaces ()
  "Setting to use spaces for tabs at a width of 4"
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (setq c-basic-offset 4))

(defun 2x2-spaces ()
  "Setting to use spaces for tabs at a width of 2"
  (interactive)
  (setq indent-tabs-mode nil)
  (setq tab-width 2)
  (setq c-basic-offset 2))

(defun 4x4-tabs ()
  "Setting to use tabs at a width of 4"
  (setq indent-tabs-mode t)
  (setq tab-width 4)
  (setq c-basic-offset 4))

;; indentation
(defun increase-indent ()
  "increase indent one level"
  (interactive)
  (indent-rigidly (region-beginning) (region-end) 2))
(defun decrease-indent ()
  "increase indent one level"
  (interactive)
  (indent-rigidly (region-beginning) (region-end) -2))
(global-set-key (kbd "s-]") 'increase-indent)
(global-set-key (kbd "s-[") 'decrease-indent)

(setq css-indent-offset 2)
(setq nxml-indent 2)

;; whitespace
;; delete trailing whitespace, except for markdown because markdown is
;; evil apparently and actually wants trailing whitespace
(defun selectively-delete-trailing-whitespace ()
    "Delete trailing whitespace, but not for markdown"
    (interactive)
    (when (not (member major-mode '(markdown-mode org-mode)))
    (delete-trailing-whitespace)
    ))
(add-hook 'before-save-hook 'selectively-delete-trailing-whitespace)

;; spelling
(add-hook 'text-mode-hook 'flyspell-mode)

;; string inflection
(require 'string-inflection)
(global-set-key (kbd "C-c s u") 'string-inflection-underscore)
(global-set-key (kbd "C-c s -") 'string-inflection-lisp)
(global-set-key (kbd "C-c s c") 'string-inflection-lower-camelcase)
(global-set-key (kbd "C-c s C") 'string-inflection-camelcase)

;; Ediff
(setq ediff-diff-options "-w")


;; lisp stuff


;; Modes
(require 'avy)
(define-key global-map (kbd "C-c SPC") 'avy-goto-word-or-subword-1)

(require 'ace-window)
(define-key global-map (kbd "s-w") 'ace-window)

(global-flycheck-mode)

(nyan-mode)
(nyan-start-animation)
(setq nyan-wavy-trail t)

;; (require 'highlight-indentation)
(add-hook 'js2-mode-hook 'highlight-indentation-current-column-mode)
(add-hook 'ruby-mode-hook 'highlight-indentation-current-column-mode)
(add-hook 'prog-mode-hook '2x2-spaces)

(require 'winner)
(when (fboundp 'winner-mode)
  (winner-mode 1))
(windmove-default-keybindings)
(setq windmove-wrap-around t)

(setq warning-minimum-level :error)

;; sql
(defun my-sql-save-history-hook ()
  (let ((lval 'sql-input-ring-file-name)
        (rval 'sql-product))
    (if (symbol-value rval)
        (let ((filename
               (concat "~/.emacs.d/sql/"
                       (symbol-name (symbol-value rval))
                       "-history.sql")))
          (set (make-local-variable lval) filename))
      (error
       (format "SQL history will not be saved because %s is nil"
               (symbol-name rval))))))

(add-hook 'sql-interactive-mode-hook 'my-sql-save-history-hook)

;; GIT
(require 'magit)
(define-key global-map "\C-xg" 'magit-status)
(add-hook 'magit-mode-hook 'turn-on-magit-gitflow)
(global-git-gutter+-mode +1)

(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

(define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)

(require 'git-gutter+)
(require 'magit-gitflow)

(if (file-exists-p "/usr/local/bin/emacsclient")
    (setq magit-emacsclient-executable "/usr/local/bin/emacsclient"))

(if (file-exists-p "/opt/boxen/homebrew/bin/emacsclient")
    (setq magit-emacsclient-executable "/opt/boxen/homebrew/bin/emacsclient"))

;; git gutter +
(global-set-key (kbd "C-x G") 'global-git-gutter+-mode) ; Turn on/off globally
(eval-after-load 'git-gutter+
  '(progn
     ;;; Jump between hunks
     (define-key git-gutter+-mode-map (kbd "M-n") 'git-gutter+-next-hunk)
     (define-key git-gutter+-mode-map (kbd "M-p") 'git-gutter+-previous-hunk)

     ;;; Act on hunks
     (define-key git-gutter+-mode-map (kbd "C-x v =") 'git-gutter+-show-hunk)
     (define-key git-gutter+-mode-map (kbd "C-x v R") 'git-gutter+-revert-hunks)
     ;; Stage hunk at point.
     ;; If region is active, stage all hunk lines within the region.
     (define-key git-gutter+-mode-map (kbd "C-x v S") 'git-gutter+-stage-hunks)
))

;; vc status line
(setq auto-revert-check-vc-info t)

;; org
(setq org-clock-idle-time 5)
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-log-done t)
(setq org-directory "~/Dropbox (Personal)/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-agenda-files (list (concat org-directory "/work.org")
                             (concat org-directory "/home.org")
                             (concat org-directory "/someday.org")
                             org-default-notes-file))
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 2))))

(setq org-todo-keywords
      '((sequence "TODO" "|" "DONE")
        (sequence "NEW" "IN PROGRESS" "|" "FIXED" "DECLINED")
        (sequence "|" "CANCELED")))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

(add-hook 'text-mode-hook 'turn-on-orgtbl)

(setq org-export-backends '(gfm md html ascii icalendar))
(setq org-file-apps
      '(("\\.docx\\'" . default)
        (auto-mode . emacs)))
;; try out helm
(require 'helm)
(require 'helm-config)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c h s") 'helm-semantic-or-imenu)

;; Don't use marks or mark-ring. Start?
(global-set-key (kbd "C-c m") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h o") 'helm-occur)

;; Don't use eshell. Start?
(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map (kbd "M-l")  'helm-eshell-history)))
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z")  'helm-select-action)
(helm-mode 1)

;; projectile
(require 'projectile)
(require 'helm-projectile)
(projectile-global-mode)
(helm-projectile-on)
(setq projectile-mode-line '(:eval (format " Proj[%s]" (projectile-project-name))))
(projectile-register-project-type 'ember-cli '("ember-cli-build.js") "ember s" "ember t -s")

;; modes

(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.thor$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Thorfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Puppetfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
(add-to-list 'auto-mode-alist '("\\.hbs$" . web-mode))

;; web mode
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'html-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)
(add-hook 'web-mode-hook  'emmet-mode)
(setq emmet-preview-default t)

(require 'company-web-html)
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (set (make-local-variable 'company-backends) '(company-web-html))
  (company-mode t)
  )
(add-hook 'web-mode-hook 'my-web-mode-hook)
(setq web-mode-markup-indent-offset 2)



;; ruby
(require 'robe)
(add-hook 'ruby-mode-hook
          (lambda ()
            (define-key (current-local-map) [remap newline] 'reindent-then-newline-and-indent)
            (local-set-key (kbd "M-.") 'robe-jump)
            (company-mode t)
            (setq ruby-insert-encoding-magic-comment nil)
            ))

;; try to get folding working
(eval-after-load "hideshow"
  '(add-to-list 'hs-special-modes-alist
                 `(ruby-mode
                   ,(rx (or "def" "class" "module" "do")) ; Block start
                   ,(rx (or "end"))                  ; Block end
                   ,(rx (or "#" "=begin"))                   ; Comment start
                   ruby-forward-sexp nil)))

;; projectile-rails
(add-hook 'projectile-mode-hook 'projectile-rails-on)
(add-hook 'after-init-hook 'inf-ruby-switch-setup)

;; rspec
(eval-after-load 'rspec-mode
 '(rspec-install-snippets))

;; inf-ruby
(add-hook 'inf-ruby-mode-hook (lambda ()
                                (set-variable 'company-idle-delay nil)
                                ))

;; javascript
(setq js-indent-level 2)
(setq coffee-tab-width 2)

(font-lock-add-keywords
 'js2-mode `(("\\(function*\\)("
                   (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                             "ƒ")
                             nil)))))
(font-lock-add-keywords 'js2-mode
                        '(("\\<\\(FIX\\|TODO\\|FIXME\\|HACK\\|REFACTOR\\):"
                           1 font-lock-warning-face t)))
(autoload 'js2-mode "js" "Start js-mode" t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;; (add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
(custom-set-variables
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p nil)
)
;; js2-refactor
(require 'js2-refactor)
(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-j")

(defun grab-jshint-globals()
  "Find jshintrc in hierarchy and return predef globals"
  (interactive)
  (when (buffer-file-name)
    (let ((dir (locate-dominating-file (buffer-file-name) ".jshintrc")))
      (when dir
        (print (cdr (assoc 'predef (json-read-file (concat dir ".jshintrc")))))
        ))
    )
  )

(add-hook 'js2-init-hook
          (lambda ()
            (setq js2-additional-externs (append (grab-jshint-globals) nil))
            ))
;; (add-hook 'js2-init-hook
;;           (lambda ()
;;             (setq js2-additional-externs '("describe"))
;;             ))

;; jscs
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c C-j f") 'jscs-fix))

(defun starter-kit-pp-json ()
  "Pretty-print the json object following point."
  (interactive)
  (require 'json)
  (let ((json-object (save-excursion (json-read))))
    (switch-to-buffer "*json*")
    (delete-region (point-min) (point-max))
    (insert (pp json-object))
    (goto-char (point-min))))

;; company mode
(add-hook 'after-init-hook 'global-company-mode)
(global-set-key (kbd "M-/") 'company-complete)
(require 'company-emoji)
(eval-after-load "company" '(company-emoji-init))
(eval-after-load 'company
  '(push 'company-robe company-backends))

(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-tooltip-align-annotations 't)          ; align annotations to the right tooltip border
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

;; ensure plain text suggestions are case sensitive
(setq company-dabbrev-downcase nil)

;; livedown markdown preview
(add-to-list 'load-path (concat ronco-es/dir "/emacs-livedown"))
(require 'livedown)

;; diminish modes
(eval-after-load "yasnippet" '(diminish 'yas-minor-mode))
(eval-after-load "project-persist" '(diminish 'project-persist-mode))
;; (eval-after-load "company" '(diminish 'company-mode))
(eval-after-load "whitespace" '(diminish 'whitespace-mode))
(eval-after-load "flycheck" '(diminish 'flycheck-mode))
(eval-after-load "helm" '(diminish 'helm-mode))
(eval-after-load "ember-mode" '(diminish 'ember-mode))
(add-hook 'js2-refactor-mode-hook (lambda ()
                               (diminish 'js2-refactor-mode)))
(add-hook 'hs-minor-mode-hook (lambda ()
                               (diminish 'hs-minor-mode)))
(diminish 'auto-fill-function)
(diminish 'smartparens-mode)
(diminish 'git-gutter+-mode)

;; buffer window toggling
(global-set-key "\C-x\C-b" 'bs-show)
(global-set-key "\C-\M-j"  'bs-cycle-next)
(global-set-key "\M-j"     'bs-cycle-previous)
(global-set-key "\M-o"     'other-window)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; disable automatic vertical window splitting (in most cases)
(setq split-height-threshold nil)


;; (global-set-key (kbd "<f8>") 'neotree-toggle)
;; (setq projectile-switch-project-action 'neotree-projectile-action)

;; folding
(require 'fold-dwim)
(global-set-key (kbd "<f7>")      'fold-dwim-toggle)
(global-set-key (kbd "<M-f7>")    'fold-dwim-hide-all)
(global-set-key (kbd "<S-M-f7>")  'fold-dwim-show-all)

(add-hook 'prog-mode-hook 'hs-minor-mode)

(defun my-scss-mode-hook ()
  "Hooks for SASS mode."
  (setq-default scss-compile-at-save nil)
  (rainbow-mode)
)
(add-hook 'scss-mode-hook 'my-scss-mode-hook)

;; livedown
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/emacs-livedown"))
;; (require 'livedown)
;; (global-set-key (kbd "C-M-m") 'livedown:preview)

;; dash
(global-set-key "\C-cd" 'dash-at-point)
(global-set-key "\C-ce" 'dash-at-point-with-docset)

;; GLOBAL BINDINGS

(fset 'triple-screen
   "\C-x1\C-x3\C-x3\C-x+")
(fset 'twin-screen
   "\C-x1\C-x3\C-x+")
(fset 'triple-u-screen
      "\C-x1\C-x2\C-x3\C-u15\C-x^")

(global-set-key (kbd "C-3") 'triple-screen)

;; load module files
(let ((module-dir (concat ronco-es/dir "/modules")))
  (when (file-exists-p module-dir)
    (print module-dir)
    (add-to-list 'load-path module-dir)
    (mapc #'load
          (directory-files module-dir t ".*\.el$"))))

;; deft mode

(require 'deft)
(global-set-key (kbd "<f8>") 'deft)
(setq deft-extensions '("md" "org" "txt"))
(setq deft-default-extension "org")
(setq deft-markdown-mode-title-level 2)
(setq deft-directory "~/Dropbox (Ibotta)/ron-notes")
(setq deft-recursive t)
(setq deft-use-filter-string-for-filename t)

;; quickly see full path
(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(global-set-key (kbd "<f1>") 'show-file-name)

;; reuse frames
;; http://emacs.stackexchange.com/questions/14125/replacing-display-buffer-reuse-frames
(add-to-list 'display-buffer-alist
             '("." nil (reusable-frames . t)))

(require 'sublimity)
(require 'sublimity-map)
(sublimity-mode 0)

(require 'edit-server)
(edit-server-start)

(print "Successfully loaded emacs-setup")
