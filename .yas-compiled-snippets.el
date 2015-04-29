;;; Compiled snippets and support files for `emacs-setup'
;;; Snippet definitions:
;;;
(yas-define-snippets 'emacs-setup
                     '(("Cask" "(source gnu)\n(source melpa)\n\n(depends-on \"better-defaults\")\n(depends-on \"coffee-mode\")\n(depends-on \"company\")\n(depends-on \"diminish\")\n(depends-on \"dockerfile-mode\")\n(depends-on \"exec-path-from-shell-initialize\")\n(depends-on \"feature-mode\")\n(depends-on \"flx-ido\")\n(depends-on \"flycheck\")\n(depends-on \"git-commit-mode\")\n(depends-on \"git-gutter+\")\n(depends-on \"git-rebase-mode\")\n(depends-on \"haml-mode\")\n(depends-on \"helm\")\n(depends-on \"helm-ag\")\n(depends-on \"helm-project-persist\")\n(depends-on \"helm-projectile\")\n(depends-on \"helm-spotify\")\n(depends-on \"highlight-indentation\")\n(depends-on \"json-mode\")\n(depends-on \"magit\")\n(depends-on \"magit-gitflow\")\n(depends-on \"markdown-mode\")\n(depends-on \"moe-theme\")\n(depends-on \"neotree\")\n(depends-on \"pallet\")\n(depends-on \"powerline\")\n(depends-on \"project-persist\")\n(depends-on \"projectile\")\n(depends-on \"puppet-mode\")\n(depends-on \"rspec-mode\")\n(depends-on \"rvm\")\n(depends-on \"slim-mode\")\n(depends-on \"smartparens\")\n(depends-on \"smex\")\n(depends-on \"yaml-mode\")\n(depends-on \"yasnippet\")\n(depends-on \"zenburn-theme\")\n" "Cask" nil nil nil nil nil nil)
                       ("README.md" "# emacs-setup\n" "README.md" nil nil nil nil nil nil)
                       ("emacs-setup.el" "\n(setq ronco-es/dir (concat\n                    user-emacs-directory\n                    \"emacs-setup\"))\n\n;; pallet mode\n(pallet-mode t)\n\n;; path\n;; add brew path\n(require 'exec-path-from-shell)\n(when (memq window-system '(mac ns))\n  (exec-path-from-shell-initialize))\n\n;; shell\n(setq explicit-bash-args '(\"--noediting\" \"--login\"))\n\n;; env setup\n(setenv \"NODENV_VERSION\" \"v0.12\")\n(setenv \"RBENV_VERSION\" \"2.1.4\")\n\n;; UTF-8\n(setq locale-coding-system 'utf-8)\n(set-terminal-coding-system 'utf-8)\n(set-keyboard-coding-system 'utf-8)\n(set-selection-coding-system 'utf-8)\n(prefer-coding-system 'utf-8)\n(set-language-environment 'utf-8)\n(set-default-coding-systems 'utf-8)\n\n;; start emacs server\n(require 'server)\n(if (server-running-p)\n    (message \"Server is running\")\n  (progn\n    (message \"Starting server\")\n    (server-start)))\n\n;; save place\n(require 'saveplace)\n(setq-default save-place t)\n(setq save-place-file (expand-file-name \".places\" user-emacs-directory))\n\n;; theme\n(require 'moe-theme)\n(moe-theme-random-color)\n(moe-dark)\n\n;; fonts\n;;(dynamic-fonts-setup)\n(if window-system\n    (set-face-attribute 'default nil :font \"Menlo-16\"))\n\n;; mode line\n(require 'powerline)\n(powerline-moe-theme)\n\n;; memory\n(setq gc-cons-threshold 20000000)\n\n;; info\n(setq user-full-name \"Ron White\"\n      user-mail-address \"ronco@costite.com\")\n\n;; command invocation\n(define-key isearch-mode-map (kbd \"C-o\")\n  (lambda () (interactive)\n    (let ((case-fold-search isearch-case-fold-search))\n      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))\n\n(global-set-key \"\\C-x\\C-m\" 'smex)\n\n;; text size\n(define-key global-map (kbd \"C-+\") 'text-scale-increase)\n(define-key global-map (kbd \"C--\") 'text-scale-decrease)\n\n;; goto line\n(global-set-key [remap goto-line] 'goto-line-with-feedback)\n\n(defun goto-line-with-feedback ()\n  \"Show line numbers temporarily, while prompting for the line number input\"\n  (interactive)\n  (unwind-protect\n      (progn\n        (linum-mode 1)\n        (goto-line (read-number \"Goto line: \")))\n    (linum-mode -1)))\n\n;; move lines\n(defun move-line-down ()\n  (interactive)\n  (let ((col (current-column)))\n    (save-excursion\n      (forward-line)\n      (transpose-lines 1))\n    (forward-line)\n    (move-to-column col)))\n\n(defun move-line-up ()\n  (interactive)\n  (let ((col (current-column)))\n    (save-excursion\n      (forward-line)\n      (transpose-lines -1))\n    (move-to-column col)))\n(global-set-key (kbd \"<C-M-S-down>\") 'move-line-down)\n(global-set-key (kbd \"<C-M-S-up>\") 'move-line-up)\n\n;; window resizing\n\n(defun increase-window-height (&optional arg)\n  \"Make the window taller by one line. Useful when bound to a repeatable key combination.\"\n  (interactive \"p\")\n  (enlarge-window arg))\n\n(defun decrease-window-height (&optional arg)\n  \"Make the window shorter by one line. Useful when bound to a repeatable key combination.\"\n  (interactive \"p\")\n  (enlarge-window (- 0 arg)))\n\n(defun decrease-window-width (&optional arg)\n  \"Make the window narrower by one line. Useful when bound to a repeatable key combination.\"\n  (interactive \"p\")\n  (enlarge-window (- 0 arg) t))\n\n(defun increase-window-width (&optional arg)\n  \"Make the window shorter by one line. Useful when bound to a repeatable key combination.\"\n  (interactive \"p\")\n  (enlarge-window arg t))\n\n(global-set-key (kbd \"C->\")\n                'increase-window-height)\n\n(global-set-key (kbd \"C-<\")\n                'decrease-window-height)\n\n(global-set-key (kbd \"C-,\")\n                'decrease-window-width)\n\n(global-set-key (kbd \"C-.\")\n                'increase-window-width)\n\n(add-hook 'org-mode-hook\n          (lambda ()\n            (define-key org-mode-map [(ctrl \\,)]\n              'decrease-window-width)))\n\n;; newline anywhere\n(defun newline-anywhere ()\n  \"Add a newline from anywhere in the line.\"\n  (interactive)\n  (end-of-line)\n  (newline-and-indent))\n\n(global-set-key (kbd \"M-RET\")\n                'newline-anywhere)\n\n;; quiet down the display\n(setq visible-bell t\n      inhibit-startup-message t)\n\n(defun major-mode-from-name ()\n  \"Choose proper mode for buffers created by switch-to-buffer.\"\n  (let ((buffer-file-name (or buffer-file-name (buffer-name))))\n    (set-auto-mode)))\n(setq-default major-mode 'major-mode-from-name)\n\n;; whitespace\n;; (global-whitespace-mode)\n\n;; yes or no\n(defalias 'yes-or-no-p 'y-or-n-p)\n\n;; autofill\n\n(defun esk-local-comment-auto-fill ()\n  (set (make-local-variable 'comment-auto-fill-only-comments) t)\n  (auto-fill-mode t))\n(add-hook 'prog-mode-hook 'esk-local-comment-auto-fill)\n\n(add-hook 'text-mode-hook 'turn-on-auto-fill)\n\n;; line & col numbers\n(setq line-number-mode t)\n(setq column-number-mode t)\n\n;; highlight current line\n(defun esk-turn-on-hl-line-mode ()\n  (when (> (display-color-cells) 8)\n    (hl-line-mode t)))\n\n(add-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)\n\n;; lambda\n(defun esk-pretty-lambdas ()\n  (font-lock-add-keywords\n   nil `((\"(?\\\\(lambda\\\\>\\\\)\"\n          (0 (progn (compose-region (match-beginning 1) (match-end 1)\n                                    ,(make-char 'greek-iso8859-7 107))\n                    nil))))))\n\n(add-hook 'prog-mode-hook 'esk-pretty-lambdas)\n\n\n;; tramp\n(setq tramp-default-method \"ssh\")\n;;     (color-theme-blackboard))\n\n;; behavioral stuff\n\n(setq ns-pop-up-frames 'nil)\n\n; code templates\n(require 'yasnippet)\n(setq yas-snippet-dirs (concat ronco-es/dir \"/snippets\"))\n\n(yas-global-mode 1)\n\n;; parens\n(require 'smartparens-config)\n(smartparens-global-mode)\n(show-smartparens-global-mode +1)\n\n\n;; xml format\n(defun xml-format ()\n  (interactive)\n  (save-excursion\n    (shell-command-on-region (mark) (point) \"xmllint --format -\" (buffer-name) t)\n  )\n)\n\n;; tabs & spaces\n(defun 4x4-spaces ()\n  \"Setting to use spaces for tabs at a width of 4\"\n  (setq indent-tabs-mode nil)\n  (setq tab-width 4)\n  (setq c-basic-offset 4))\n\n(defun 2x2-spaces ()\n  \"Setting to use spaces for tabs at a width of 2\"\n  (interactive)\n  (setq indent-tabs-mode nil)\n  (setq tab-width 2)\n  (setq c-basic-offset 2))\n\n(defun 4x4-tabs ()\n  \"Setting to use tabs at a width of 4\"\n  (setq indent-tabs-mode t)\n  (setq tab-width 4)\n  (setq c-basic-offset 4))\n\n;; indentation\n(defun increase-indent ()\n  \"increase indent one level\"\n  (interactive)\n  (indent-rigidly (region-beginning) (region-end) 2))\n(defun decrease-indent ()\n  \"increase indent one level\"\n  (interactive)\n  (indent-rigidly (region-beginning) (region-end) -2))\n(global-set-key (kbd \"s-]\") 'increase-indent)\n(global-set-key (kbd \"s-[\") 'decrease-indent)\n\n(setq css-indent-offset 2)\n(setq nxml-indent 2)\n\n;; whitespace\n(add-hook 'before-save-hook 'delete-trailing-whitespace)\n\n;; Ediff\n(setq ediff-diff-options \"-w\")\n\n;; (defun ron-js-hook ()\n;;   \"My JS settings\"\n;;   (whitespace-mode)\n;;   (flycheck-mode)\n;;   )\n\n;; (add-hook 'js-mode-hook 'ron-js-hook)\n\n;; lisp stuff\n\n\n;; Modes\n(require 'highlight-indentation)\n(add-hook 'prog-mode-hook 'highlight-indentation-current-column-mode)\n(add-hook 'prog-mode-hook '2x2-spaces)\n\n(when (fboundp 'winner-mode)\n  (winner-mode 1))\n(windmove-default-keybindings)\n(setq windmove-wrap-around t)\n\n(setq warning-minimum-level :error)\n\n;; GIT\n(require 'magit)\n(require 'git-gutter+)\n(require 'magit-gitflow)\n(define-key global-map \"\\C-xg\" 'magit-status)\n(add-hook 'magit-mode-hook 'turn-on-magit-gitflow)\n(global-git-gutter+-mode +1)\n\n(defadvice magit-status (around magit-fullscreen activate)\n  (window-configuration-to-register :magit-fullscreen)\n  ad-do-it\n  (delete-other-windows))\n\n(defun magit-quit-session ()\n  \"Restores the previous window configuration and kills the magit buffer\"\n  (interactive)\n  (kill-buffer)\n  (jump-to-register :magit-fullscreen))\n\n(define-key magit-status-mode-map (kbd \"q\") 'magit-quit-session)\n\n(defun magit-toggle-whitespace ()\n  (interactive)\n  (if (member \"-w\" magit-diff-options)\n      (magit-dont-ignore-whitespace)\n    (magit-ignore-whitespace)))\n\n(defun magit-ignore-whitespace ()\n  (interactive)\n  (add-to-list 'magit-diff-options \"-w\")\n  (magit-refresh))\n\n(defun magit-dont-ignore-whitespace ()\n  (interactive)\n  (setq magit-diff-options (remove \"-w\" magit-diff-options))\n  (magit-refresh))\n\n(define-key magit-status-mode-map (kbd \"W\") 'magit-toggle-whitespace)\n\n(if (file-exists-p \"/usr/local/bin/emacsclient\")\n    (setq magit-emacsclient-executable \"/usr/local/bin/emacsclient\"))\n\n(if (file-exists-p \"/opt/boxen/homebrew/bin/emacsclient\")\n    (setq magit-emacsclient-executable \"/opt/boxen/homebrew/bin/emacsclient\"))\n\n;; git gutter +\n(global-set-key (kbd \"C-x G\") 'global-git-gutter+-mode) ; Turn on/off globally\n(eval-after-load 'git-gutter+\n  '(progn\n     ;;; Jump between hunks\n     (define-key git-gutter+-mode-map (kbd \"C-x n\") 'git-gutter+-next-hunk)\n     (define-key git-gutter+-mode-map (kbd \"C-x p\") 'git-gutter+-previous-hunk)\n\n     ;;; Act on hunks\n     (define-key git-gutter+-mode-map (kbd \"C-x v =\") 'git-gutter+-show-hunk)\n     (define-key git-gutter+-mode-map (kbd \"C-x r\") 'git-gutter+-revert-hunks)\n     ;; Stage hunk at point.\n     ;; If region is active, stage all hunk lines within the region.\n     (define-key git-gutter+-mode-map (kbd \"C-x t\") 'git-gutter+-stage-hunks)\n))\n\n;; GLOBAL BINDINGS\n\n(fset 'triple-screen\n   \"\\C-x1\\C-x3\\C-x3\\C-x+\")\n(fset 'twin-screen\n   \"\\C-x1\\C-x3\\C-x+\")\n(fset 'triple-u-screen\n      \"\\C-x1\\C-x2\\C-x3\\C-u15\\C-x^\")\n\n(global-set-key (kbd \"C-3\") 'triple-screen)\n\n;; org\n(setq org-clock-idle-time 5)\n(require 'org-install)\n(add-to-list 'auto-mode-alist '(\"\\\\.org$\" . org-mode))\n(setq org-log-done t)\n(setq org-directory \"~/Dropbox (Personal)/org\")\n(setq org-default-notes-file (concat org-directory \"/notes.org\"))\n(setq org-agenda-files (list (concat org-directory \"/work.org\")\n                             (concat org-directory \"/home.org\")\n                             (concat org-directory \"/someday.org\")\n                             org-default-notes-file))\n(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 2))))\n\n(setq org-todo-keywords\n      '((sequence \"TODO\" \"|\" \"DONE\")\n        (sequence \"NEW\" \"IN PROGRESS\" \"|\" \"FIXED\" \"DECLINED\")\n        (sequence \"|\" \"CANCELED\")))\n(define-key global-map \"\\C-cl\" 'org-store-link)\n(define-key global-map \"\\C-ca\" 'org-agenda)\n(define-key global-map \"\\C-cc\" 'org-capture)\n\n(add-hook 'text-mode-hook 'turn-on-orgtbl)\n\n;; try out helm\n(require 'helm)\n(require 'helm-config)\n\n(global-set-key (kbd \"M-x\") 'helm-M-x)\n(global-set-key (kbd \"C-x b\") 'helm-mini)\n(global-set-key (kbd \"M-y\") 'helm-show-kill-ring)\n(global-set-key (kbd \"C-x C-f\") 'helm-find-files)\n(global-set-key (kbd \"C-c h s\") 'helm-semantic-or-imenu)\n\n;; Don't use marks or mark-ring. Start?\n(global-set-key (kbd \"C-c m\") 'helm-all-mark-rings)\n(global-set-key (kbd \"C-c h o\") 'helm-occur)\n\n;; Don't use eshell. Start?\n(add-hook 'eshell-mode-hook\n          #'(lambda ()\n              (define-key eshell-mode-map (kbd \"M-l\")  'helm-eshell-history)))\n(define-key helm-map (kbd \"<tab>\") 'helm-execute-persistent-action)\n(define-key helm-map (kbd \"C-z\")  'helm-select-action)\n(helm-mode 1)\n\n;; projectile\n(require 'projectile)\n(require 'helm-projectile)\n(projectile-global-mode)\n(helm-projectile-on)\n\n\n;; modes\n\n(add-to-list 'auto-mode-alist '(\"\\\\.md$\" . markdown-mode))\n(add-to-list 'auto-mode-alist '(\"\\\\.pp$\" . puppet-mode))\n(add-to-list 'auto-mode-alist '(\"\\\\.yml$\" . yaml-mode))\n(setq js-indent-level 2)\n(setq coffee-tab-width 2)\n(add-to-list 'auto-mode-alist '(\"\\\\.rake$\" . ruby-mode))\n(add-to-list 'auto-mode-alist '(\"\\\\.gemspec$\" . ruby-mode))\n(add-to-list 'auto-mode-alist '(\"\\\\.ru$\" . ruby-mode))\n(add-to-list 'auto-mode-alist '(\"Rakefile$\" . ruby-mode))\n(add-to-list 'auto-mode-alist '(\"Gemfile$\" . ruby-mode))\n(add-to-list 'auto-mode-alist '(\"Capfile$\" . ruby-mode))\n(add-to-list 'auto-mode-alist '(\"Vagrantfile$\" . ruby-mode))\n(add-to-list 'auto-mode-alist '(\"\\\\.thor$\" . ruby-mode))\n(add-to-list 'auto-mode-alist '(\"Thorfile$\" . ruby-mode))\n(add-to-list 'auto-mode-alist '(\"Guardfile\" . ruby-mode))\n(add-to-list 'auto-mode-alist '(\"Puppetfile$\" . ruby-mode))\n(add-hook 'ruby-mode-hook\n          (lambda ()\n            (define-key (current-local-map) [remap newline] 'reindent-then-newline-and-indent)))\n\n;; company mode\n(add-hook 'after-init-hook 'global-company-mode)\n(global-set-key (kbd \"M-/\") 'company-complete)\n\n\n;; diminish modes\n(eval-after-load \"yasnippet\" '(diminish 'yas-minor-mode))\n(eval-after-load \"project-persist\" '(diminish 'project-persist-mode))\n(eval-after-load \"company\" '(diminish 'company-mode))\n(diminish 'auto-fill-function)\n(diminish 'magit-auto-revert-mode)\n(diminish 'smartparens-mode)\n(diminish 'git-gutter+-mode)\n\n\n;; buffer window toggling\n(global-set-key \"\\C-x\\C-b\" 'bs-show)\n(global-set-key \"\\C-\\M-j\"  'bs-cycle-next)\n(global-set-key \"\\M-j\"     'bs-cycle-previous)\n(global-set-key \"\\M-o\"     'other-window)\n(global-set-key (kbd \"<C-S-up>\")     'buf-move-up)\n(global-set-key (kbd \"<C-S-down>\")   'buf-move-down)\n(global-set-key (kbd \"<C-S-left>\")   'buf-move-left)\n(global-set-key (kbd \"<C-S-right>\")  'buf-move-right)\n\n(global-set-key (kbd \"<f8>\") 'neotree-toggle)\n;; (setq projectile-switch-project-action 'neotree-projectile-action)\n\n;; folding\n(require 'fold-dwim)\n(global-set-key (kbd \"<f7>\")      'fold-dwim-toggle)\n(global-set-key (kbd \"<M-f7>\")    'fold-dwim-hide-all)\n(global-set-key (kbd \"<S-M-f7>\")  'fold-dwim-show-all)\n\n(defun my-scss-mode-hook ()\n  \"Hooks for SASS mode.\"\n  (setq-default scss-compile-at-save nil)\n  (rainbow-mode)\n)\n(add-hook 'scss-mode-hook 'my-scss-mode-hook)\n\n;; livedown\n;; (add-to-list 'load-path (expand-file-name \"~/.emacs.d/emacs-livedown\"))\n;; (require 'livedown)\n;; (global-set-key (kbd \"C-M-m\") 'livedown:preview)\n\n;; dash\n(global-set-key \"\\C-cd\" 'dash-at-point)\n(global-set-key \"\\C-ce\" 'dash-at-point-with-docset)\n\n;; Enable paredit for a couple for non lisp modes; tweak\n;; paredit-space-for-delimiter-predicates to avoid inserting spaces\n;; before open parens.\n(dolist (mode '(ruby js yaml))\n  (add-hook (intern (format \"%s-mode-hook\" mode))\n            '(lambda ()\n               (add-to-list (make-local-variable 'paredit-space-for-delimiter-predicates)\n                            (lambda (_ _) nil))\n               (enable-paredit-mode)\n               (electric-pair-mode)\n               )))\n" "emacs-setup.el" nil nil nil nil nil nil)
                       ("init.el" "(require 'cask (concat ronco-cask-dir \"cask.el\"))\n(cask-initialize)\n(require 'pallet)\n(load (concat user-emacs-directory \"emacs-setup/emacs-setup.el\"))\n" "init.el" nil nil nil nil nil nil)
                       ("install.sh" "#!/bin/bash\n\nemacs_setup_dir=`pwd`\n\necho \"Creating $HOME/.emacs.d (if needed)\"\nmkdir -p $HOME/.emacs.d\n\necho \"Creating $HOME/.emacs.d/emacs-setup as link to $emacs_setup_dir\"\nln -s $emacs_setup_dir $HOME/.emacs.d/emacs-setup\n\necho \"Creating $HOME/.emacs.d/init.el\"\nBREW_PREFIX=$(brew --prefix)\nCASK_VERSION=$(cask --version)\nCASK_DIR=\"${BREW_PREFIX}/Cellar/cask/${CASK_VERSION}/\"\necho \"(setq ronco-cask-dir \\\"${CASK_DIR}\\\")\" > init.el.tmp\ncat init.el >> init.el.tmp\nmv init.el.tmp $HOME/.emacs.d/init.el\n\necho \"Creating $HOME/.emacs.d/Cask\"\nln -s $emacs_setup_dir/Cask $HOME/.emacs.d/Cask\n\npushd $HOME/.emacs.d\necho \"Installing Packages with Cask\"\ncask install\npopd\n" "install.sh" nil nil nil nil nil nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'emacs-setup
                     '(("ib-anal" "  analytics: Em.inject.service('google-analytics')" "inject analytics" nil nil nil nil "direct-keybinding" nil)
                       ("ib-data" "\\`import ibottaData from 'ibotta-web/utils/ibotta-data'\\`" "import ibotta data" nil nil nil nil "direct-keybinding" nil)
                       ("ib-element" "\\`import ModelElementIdMixin from 'ibotta-web/mixins/model-element-id'\\`\n" "model element id" nil nil nil nil "direct-keybinding" nil)
                       ("ib-env" "\\`import ENV from 'ibotta-web/config/environment'`" "import environment" nil nil nil nil "direct-keybinding" nil)
                       ("ib-log" "\\`import logger from 'ibotta-web/utils/logger'\\`\n" "import logger" nil nil nil nil "direct-keybinding" nil)
                       ("ib-session" "  session: Em.inject.service 'session'" "inject session" nil nil nil nil "direct-keybinding" nil)
                       ("ib-static" "\\`import staticConstants from 'ibotta-web/utils/static-constants'\\`\n" "import static constants" nil nil nil nil nil nil)
                       ("ib-utils" "\\`import ibottaUtilities from 'ibotta-web/utils/ibotta-utilities'\\`" "import utilities" nil nil nil nil "direct-keybinding" nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'emacs-setup
                     '(("be" "beforeEach(function(){\n$0\n});" "before-each" nil nil nil nil "direct-keybinding" nil)
                       (".then" ".then(function(${1:value}) {\n$0\n});" "chain-then" nil nil nil nil "direct-keybinding" nil)
                       ("desc" "describe('${1:description}', function(){\n$0\n});" "describe" nil nil nil nil "direct-keybinding" nil)
                       ("ib-anal" "  analytics: Em.inject.service('google-analytics')," "inject analytics" nil nil nil nil "direct-keybinding" nil)
                       ("ib-assert" "logger.assert('${2:description}', ${1:condition});$0" "ib-assert" nil nil nil nil "direct-keybinding" nil)
                       ("ib-data" "import ibottaData from 'ibotta-web/utils/ibotta-data';" "import ibotta data" nil nil nil nil "direct-keybinding" nil)
                       ("ib-element" "import ModelElementIdMixin from 'ibotta-web/mixins/model-element-id';\n" "model element id" nil nil nil nil "direct-keybinding" nil)
                       ("ib-env" "import ENV from 'ibotta-web/config/environment;" "import environment" nil nil nil nil "direct-keybinding" nil)
                       ("ib-logger" "import logger from 'ibotta-web/utils/logger';\n" "import logger" nil nil nil nil "direct-keybinding" nil)
                       ("ib-session" "  session: Em.inject.service('session')," "inject session" nil nil nil nil "direct-keybinding" nil)
                       ("ib-static" "import staticConstants from 'ibotta-web/utils/static-constants';\n" "import static constants" nil nil nil nil "direct-keybinding" nil)
                       ("ib-utils" "import ibottaUtilities from 'ibotta-web/utils/ibotta-utilities';" "import utilities" nil nil nil nil "direct-keybinding" nil)
                       ("its" "it('${1:description}', function(){\n$0\n});" "it synchronous" nil nil nil nil "direct-keybinding" nil)
                       ("then" "${1:promise}.then(function() {\n$0\n});" "promise-then" nil nil nil nil "direct-keybinding" nil)
                       ("sup" "this._super.apply(this, arguments);" "super" nil nil nil nil "direct-keybinding" nil)))


;;; Do not edit! File generated at Tue Apr 28 17:56:04 2015