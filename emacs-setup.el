
(setq ronco-es/dir (concat
                    user-emacs-directory
                    "emacs-setup"))

;; projectile
(projectile-global-mode)

;; path
;; add brew path
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; shell
(setq explicit-bash-args '("--noediting" "--login"))

;; env setup
(setenv "NODENV_VERSION" "v0.12")
(setenv "RBENV_VERSION" "2.1.4")

;; UTF-8
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)

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
    (set-face-attribute 'default nil :font "Menlo-16"))

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
(setq visible-bell t
      inhibit-startup-message t)

(defun major-mode-from-name ()
  "Choose proper mode for buffers created by switch-to-buffer."
  (let ((buffer-file-name (or buffer-file-name (buffer-name))))
    (set-auto-mode)))
(setq-default major-mode 'major-mode-from-name)

;; whitespace
(global-whitespace-mode)

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
;;     (color-theme-blackboard))

;; behavioral stuff

(setq ns-pop-up-frames 'nil)

; code templates
(require 'yasnippet)
(setq yas-snippet-dirs (concat ronco-es/dir "/snippets"))

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
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Ediff
(setq ediff-diff-options "-w")

(defun ron-js-hook ()
  "My JS settings"
  (whitespace-mode)
  (flycheck-mode)
  )

(add-hook 'js-mode-hook 'ron-js-hook)

;; lisp stuff


;; Modes
(require 'highlight-indentation)
(add-hook 'prog-mode-hook 'highlight-indentation-current-column-mode)
(add-hook 'prog-mode-hook '2x2-spaces)

(when (fboundp 'winner-mode)
  (winner-mode 1))
(windmove-default-keybindings)
(setq windmove-wrap-around t)

(setq warning-minimum-level :error)

;; GIT
(require 'magit)
(require 'git-gutter)
(require 'magit-gitflow)
(define-key global-map "\C-xg" 'magit-status)
(add-hook 'magit-mode-hook 'turn-on-magit-gitflow)
(global-git-gutter-mode +1)

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

(if (file-exists-p "/usr/local/bin/emacsclient")
    (setq magit-emacsclient-executable "/usr/local/bin/emacsclient"))

(if (file-exists-p "/opt/boxen/homebrew/bin/emacsclient")
    (setq magit-emacsclient-executable "/opt/boxen/homebrew/bin/emacsclient"))


;; GLOBAL BINDINGS

(fset 'triple-screen
   "\C-x1\C-x3\C-x3\C-x+")
(fset 'twin-screen
   "\C-x1\C-x3\C-x+")
(fset 'triple-u-screen
      "\C-x1\C-x2\C-x3\C-u15\C-x^")

(global-set-key (kbd "C-3") 'triple-screen)

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

;; modes

(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(setq js-indent-level 2)
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
(add-hook 'ruby-mode-hook
          (lambda ()
            (define-key (current-local-map) [remap newline] 'reindent-then-newline-and-indent)))

;; diminish modes
(eval-after-load "yasnippet" '(diminish 'yas-minor-mode))
(eval-after-load "project-persist" '(diminish 'project-persist-mode))
(eval-after-load "company" '(diminish 'company-mode))
(diminish 'auto-fill-function)
(diminish 'magit-auto-revert-mode)
(diminish 'smartparens-mode)


;; buffer window toggling
(global-set-key "\C-x\C-b" 'bs-show)
(global-set-key "\C-\M-j"  'bs-cycle-next)
(global-set-key "\M-j"     'bs-cycle-previous)
(global-set-key "\M-o"     'other-window)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

(global-set-key (kbd "<f8>") 'neotree-toggle)
;; (setq projectile-switch-project-action 'neotree-projectile-action)

;; folding
(require 'fold-dwim)
(global-set-key (kbd "<f7>")      'fold-dwim-toggle)
(global-set-key (kbd "<M-f7>")    'fold-dwim-hide-all)
(global-set-key (kbd "<S-M-f7>")  'fold-dwim-show-all)

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

;; Enable paredit for a couple for non lisp modes; tweak
;; paredit-space-for-delimiter-predicates to avoid inserting spaces
;; before open parens.
(dolist (mode '(ruby js yaml))
  (add-hook (intern (format "%s-mode-hook" mode))
            '(lambda ()
               (add-to-list (make-local-variable 'paredit-space-for-delimiter-predicates)
                            (lambda (_ _) nil))
               (enable-paredit-mode)
               (electric-pair-mode)
               )))
