;;; Set Emacs settings  -*- lexical-binding: t; -*-

;; Reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; Warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

;;; Tweak UI elements

;; Set fonts
(set-face-attribute 'default nil :font "FiraCode NF" :height 135)

;; Disable the default startup screen
(setq inhibit-startup-message t)
;; Disable scrollbar
(scroll-bar-mode -1)
;; Disable menu bar
(menu-bar-mode -1)
;; Disable tool bar
(tool-bar-mode -1)
;; Disable tooltips
(tooltip-mode -1)
;; Set the fringe/padding around the window to a few pixels
(set-fringe-mode 4)
;; Enable line numbers
(global-display-line-numbers-mode 1)
;; Highlight the cursor line
(global-hl-line-mode 1)


;;; Keyboard settings

;; <escape> quits prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;;; Packages

;; Add melpa as a package repo
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Refresh the package archives if empty
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not installed already
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Define all the packages I use
(require 'use-package)

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-Y-yank-to-eol t
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package which-key
  :ensure t
  :diminish
  :init
  (setq which-key-allow-evil-operators t)
  :config
  (which-key-mode 1))

(use-package company
  :ensure t
  :diminish
  :config
  (global-company-mode))

(use-package parinfer-rust-mode
  :ensure t
  :hook emacs-lisp-mode
  :init
  (setq parinfer-rust-auto-download t))

(use-package rainbow-delimiters
  :ensure t
  :diminish
  :hook (emacs-lisp-mode . rainbow-delimiters-mode))

(use-package all-the-icons
  :ensure t)

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-minor-modes t)
  :hook (after-init . doom-modeline-mode))
