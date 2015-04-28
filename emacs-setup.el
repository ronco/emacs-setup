;; Initial old setup

;; projectile
(projectile-global-mode)

;; path
;; add brew path
(require 'exec-path-from-shell
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; fonts
;;(dynamic-fonts-setup)
(if window-system
    (set-face-attribute 'default nil :font "Menlo-18"))

;; whitespace
(global-whitespace-mode)

;; tramp
(setq tramp-default-method "ssh")
;;     (color-theme-blackboard))

;; behavioral stuff

(setq ns-pop-up-frames 'nil)

; code templates
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/snippets")

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

;; start emacs server
(server-start)

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
