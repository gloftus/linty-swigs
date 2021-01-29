;; init.basic.org
;; a basic emacs init file

;; expects the following directories and files to exist:
;;
;; ~/.emacs.d/themes/mustard-theme.el
;; ~/.emacs.d/elisp/customize.el
;; ~/.emacs.d/elisp/local-config.el
;; ~/.emacs.d/backup

;; package mgmt
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (add-to-list 'load-path "~/.emacs/")
  (require 'use-package))

;; basic defaults
(setq-default
 confirm-kill-emacs 'yes-or-no-p                  ; Confirm before exiting Emacs
 cursor-in-non-selected-windows t                 ; Hide the cursor in inactive windows
 fill-column 80                                   ; Set width for automatic line breaks
 help-window-select t                             ; Focus new help windows when opened
 inhibit-startup-screen t                         ; Disable start-up screen
 initial-scratch-message ""                       ; Empty the initial *scratch* buffer
 select-enable-clipboard t                        ; Merge system's and Emacs' clipboard
 uniquify-buffer-name-style 'forward              ; Uniquify buffer names
 column-number-mode 1                             ; turn on column mode?
 indent-tabs-mode nil                             ; Stop using tabs to indent
 tab-width 4                                      ; Set width for tabs
 scroll-margin 10                                 ; Add a margin when scrolling vertically
 scroll-conservatively most-positive-fixnum       ; Always scroll by one line
)

(when window-system
  (blink-cursor-mode 0)
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (tooltip-mode 0))

(fset 'yes-or-no-p 'y-or-n-p)                     ; Replace yes/no prompts with y/n
(menu-bar-mode 0)                                 ; Disable the menu bar
(global-set-key (kbd "C-<right>") 'other-window)
(global-set-key (kbd "C-<left>") 'other-window)
(setq backup-directory-alist '(("." . "~/.emacs.d/backup")))

;; basic environment
(add-to-list 'load-path "~/.emacs.d/elisp/")
(load "local-config")
(setq custom-file "~/.emacs.d/elisp/customize.el")
(load custom-file)

;; basic theme
(setq custom-theme-directory "~/.emacs.d/themes/")
(load-theme 'mustard t)

;; basic org
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(setq org-agenda-window-setup 'other-window)
(setq org-export-backends (quote (ascii html icalendar latex md)))
(setq org-src-fontify-natively t)
(setq org-confirm-babel-evaluate nil)
(setq org-catch-invisible-edits 'show-and-error)
(org-babel-do-load-languages 'org-babel-load-languages '(
  (python . t) (java . t) (js . t) (C . t) (R . t)
  (shell . t) (emacs-lisp . t)
))

;; basic softdev
(use-package magit
  :ensure t)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)

