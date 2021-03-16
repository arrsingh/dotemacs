; Set background and foreground colors

(add-to-list 'default-frame-alist '(foreground-color . "MediumAquamarine"))
(add-to-list 'default-frame-alist '(background-color . "black"))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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

;; Install tide mode manually from the github source so that we can
;; get the latest version that supports handling identifiers that span
;; multiple lines
(add-to-list 'load-path "~/.emacs.d/tide")
(require 'tide)

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

(defun make-check ()
  "Run make run without arguments"
  (interactive)
  (run-make "check"))

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
 '(indent-tabs-mode nil)
 '(package-selected-packages
   '(use-package doom-modeline doom-themes all-the-icons neotree yasnippet web-mode rjsx-mode typescript-mode lsp-ui company cargo helm-projectile projectile helm rust-mode exec-path-from-shell go-mode magit lsp-mode)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;(require 'go-autocomplete)
;(require 'auto-complete-config)
;(require 'auto-complete)
;(ac-config-default)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

;(require 'go-guru)
;(go-guru-hl-identifier-mode)
;(add-hook 'go-mode-hook #'go-guru-hl-identifier-mode)

(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(global-set-key "\M-v" 'down-slightly)
(global-set-key "\C-v" 'up-slightly)

(global-set-key "\M-g" 'goto-line)
(setq rust-format-on-save t)

(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "M-x") #'helm-M-x)

(helm-mode 1)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)

(require 'lsp-mode)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'rust-mode-hook 'cargo-minor-mode)
(require 'rust-mode)
(define-key rust-mode-map (kbd "M-n") 'next-error)
(define-key rust-mode-map (kbd "M-p") 'previous-error)

(define-key rust-mode-map (kbd "C-c C-t") 'cargo-process-test)
(define-key rust-mode-map (kbd "C-c C-b") 'cargo-process-build)
(define-key rust-mode-map (kbd "C-c C-r") 'cargo-process-run)

(global-set-key (kbd "s-n") nil)

;; redefine cargo-process test to use -- --nocapture
(defun cargo-process-test ()
  "Run the Cargo test command.
With the prefix argument, modify the command's invocation.
Cargo: Run the tests."
  (interactive)
  (cargo-process--start "Test" "cargo test -- --nocapture"))

(global-set-key (kbd "C-c C-t") 'cargo-process-test)
(global-set-key (kbd "C-c C-b") 'cargo-process-build)
(global-set-key (kbd "C-c C-r") 'cargo-process-run)
(global-set-key (kbd "C-c C-o") 'comment-region)
(global-set-key (kbd "C-c C-u") 'uncomment-region)
(global-set-key (kbd "C-c C-h") 'lsp-describe-thing-at-point)
(setq lsp-ui-doc-enable nil)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(require 'flycheck)
(flycheck-add-mode 'typescript-tslint 'web-mode)

(setq projectile-switch-project-action 'neotree-projectile-action)
(setq neo-smart-open t)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(add-to-list 'load-path "~/.emacs.d/w3m-20210226.23")

(require 'w3m)

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-vibrant t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  ;;(setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  ;;(doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(set-frame-font "Menlo:pixelsize=14")
