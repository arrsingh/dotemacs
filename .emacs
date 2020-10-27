; Set background and foreground colors

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'default-frame-alist '(foreground-color . "MediumAquamarine"))
(add-to-list 'default-frame-alist '(background-color . "black"))

;disable menu bar and toolbar
(menu-bar-mode -1)
(tool-bar-mode -1)

;Use zshell as the shell
(setq explicit-shell-file-name "/bin/zsh")
;;Set the default dir
(setq default-directory "~/")
(setq inhibit-startup-message t)
(setq column-number-mode t)
;; Don't indent with tabs. Indent with spaces
(setq indent-tabs-mode nil)
;;Show parenthesis
(show-paren-mode t)
;;Delete trailing whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;;Tabs are 4 spaces
(setq-default tab-width 4)
;;Elisp files go in .elisp
(add-to-list 'load-path "~/.emacs.d/elisp/")

(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "http://stable.melpa.org/packages/") t)

;;Dired should only show the full dir. Brief is useless
(global-set-key "\C-x\C-d" 'dired)
(global-set-key [?\s-p] 'comint-previous-input)

(setq ring-bell-function 'ignore)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ns-print-buffer ()
  "Override the print buffer command so it doesn't actually print"
  (interactive)
  (message "BAM! Printing Buffer!"))

(defun nshell ()
  "creates a new shell and prompts for a name"
  (interactive)
  (shell (read-no-blanks-input "Shell Name: " "*shell*")))

(defun run-make (&optional arg)
  "Invoke make with an argument"
  (compile (concat "make " arg))
;  (switch-to-buffer "*compilation*")
  (goto-char (point-max)))

(defun make ()
  "Invoke the make command without arguments"
  (interactive)
  (run-make ""))

(defun make-test ()
  "Run make test without arguments"
  (interactive)
  (run-make "test"))

(defun make-install ()
  "Run make test without arguments"
  (interactive)
  (run-make "install"))

(defun make-run ()
  "Run make run without arguments"
  (interactive)
  (run-make "run"))

(defun make-clean ()
  "Run make run without arguments"
  (interactive)
  (run-make "clean"))

(defun cdshell()
  (interactive)
  (let (
	(shell-dir (shell-quote-argument (replace-regexp-in-string "^~" (getenv "HOME") default-directory)))
	)
    (shell)		;; start new one or use existing
    (end-of-buffer)	;; make sure you are at command prompt
    (insert "cd ")
    (insert shell-dir)
    (comint-send-input)
    )
  )

(defun git-status ()
  "Runs git status using magit"
  (interactive)
  (magit-status))

;;Call gofmt everytime a file is saved
(add-to-list 'exec-path "/usr/local/go/bin")
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

(defalias 'shellcd 'cdshell)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
	(go-autocomplete auto-complete exec-path-from-shell go-mode magit))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

(require 'go-guru)
(go-guru-hl-identifier-mode)
(add-hook 'go-mode-hook #'go-guru-hl-identifier-mode)

(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(global-set-key "\M-v" 'down-slightly)
(global-set-key "\C-v" 'up-slightly)

(global-set-key "\M-g" 'goto-line)
