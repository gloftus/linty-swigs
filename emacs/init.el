;; Filename: init.el
;; Author: Gregory Loftus
;; Build date: Thu Jan 28 20:49:17 EST 2021
;; Source: github.com/gloftus/linty-swigs/emacs/init.org

(add-to-list 'load-path "~/.emacs.d/elisp/")
(setq custom-file "~/.emacs.d/elisp/customize.el")
(setq backup-directory-alist '(("." . "/home/gloftus/.emacs.d/backup")))

;; a bugfix for deprecated common lisp package
(setq byte-compile-warnings '(cl-functions))

(require 'package)
(setq package-enable-at-startup nil)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :config
  (general-create-definer efs/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (efs/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; my prefered window switching
(global-set-key (kbd "C-<right>") 'other-window)
(global-set-key (kbd "C-<left>") 'other-window)

(setq-default
 confirm-kill-emacs 'yes-or-no-p
 cursor-in-non-selected-windows t            ; Hide the cursor in inactive windows
 help-window-select t                        ; Focus new help windows when opened
 inhibit-startup-screen t
 initial-scratch-message ""
 select-enable-clipboard t                   ; Merge system's and Emacs' clipboard
 uniquify-buffer-name-style 'forward
 indent-tabs-mode nil
 tab-width 4
 scroll-margin 10                            ; Add a margin when scrolling vertically
 scroll-conservatively most-positive-fixnum  ; Always scroll by one line
 show-trailing-whitespace nil                  ; Display trailing whitespaces
)

(when window-system
  (blink-cursor-mode 0)
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (tooltip-mode 0)
  (menu-bar-mode 0))

(fset 'yes-or-no-p 'y-or-n-p)
(setq frame-title-format (concat  "%b - emacs@" (system-name)))

(column-number-mode 1)
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
                org-agenda-finalize-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(global-visual-line-mode 1)
(global-display-fill-column-indicator-mode 1)

(defun gwl/org-mode-visual-fill ()
 (setq visual-fill-column-width 100
  visual-fill-column-center-text t)
 (visual-fill-column-mode 1))

(use-package visual-fill-column
  :init
  (global-visual-fill-column-mode 1)
  (setq-default display-fill-column-indicator-character 9550)
  (setq-default display-fill-column-indicator-column 79)
  :hook (org-mode . gwl/org-mode-visual-fill))

(dolist (mode '(org-agenda-finalize-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-fill-column-indicator-mode 0))))

(use-package doom-themes
  :init (load-theme 'doom-palenight t))

(defun gwl/font-exists (font) "check if font exists"
  (if (null (x-list-fonts font)) nil t))
(if (gwl/font-exists "Hack")
  (set-face-attribute 'default nil :font "Hack" :height 130))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (
    ("C-s" . swiper)
    :map ivy-minibuffer-map
      ("TAB" . ivy-alt-done)
      ("C-l" . ivy-alt-done)
      ("C-j" . ivy-next-line)
      ("C-k" . ivy-previous-line)
    :map ivy-switch-buffer-map
      ("C-k" . ivy-previous-line)
      ("C-l" . ivy-done)
      ("C-d" . ivy-switch-buffer-kill)
    :map ivy-reverse-i-search-map
      ("C-k" . ivy-previous-line)
      ("C-d" . ivy-reverse-i-search-kill))
  :config (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
    :map minibuffer-local-map ("C-r" . 'counsel-minibuffer-history))
  :custom (counsel-linux-app-format-function
           #'counsel-linux-app-format-function-name-only)
  :config (counsel-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; Uncomment the following line to have sorting remembered across sessions!
  ;(prescient-persist-mode 1)
(ivy-prescient-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function) ([remap
  describe-command] . helpful-command) ([remap describe-variable]
  . counsel-describe-variable) ([remap describe-key] . helpful-key))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(global-subword-mode 1)      ; Iterate through CamelCase words

(use-package web-mode
  :ensure t
;;  :delight web-mode "Web"
;;  :config (setq-default web-mode-enable-auto-indentation nil)
)

(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(setq org-agenda-window-setup 'other-window)
(setq org-deadline-warning-days 45)

(setq org-agenda-span 8
      org-agenda-start-on-weekday nil
      org-agenda-start-day "+0d")

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
         "* TODO %?\n  %i\n")
        ("e" "Emacs Complaints" entry (file+headline "~/pgm/emacs/emacs.org" "complaints")
         "** %?\nEntered on %U\n")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n  %i\n")))

(setq org-src-fontify-natively t) ;; fontify source blocks
(setq org-confirm-babel-evaluate nil)
(org-babel-do-load-languages 'org-babel-load-languages '(
  (python . t) (java . t) (js . t) (C . t) (R . t) (shell . t) (emacs-lisp . t)
))

(setq org-export-backends (quote (ascii html icalendar latex md)))
(setq org-catch-invisible-edits 'show-and-error)

(setq org-catch-invisible-edits 'show-and-error)

;; This is needed as of Org 9.2
(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

;; Automatically tangle our Emacs.org config file when we save it
(defun gwl/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'gwl/org-babel-tangle-config)))

(use-package magit
  :ensure t)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)

(use-package tex
 :ensure auctex)

(use-package pdf-tools
 :config
 (pdf-tools-install)
 (setq-default pdf-view-display-size 'fit-page)
 (setq pdf-view-resize-factor 1.1)
 ;; automatically annotate highlights
 ;;(setq pdf-annot-activate-created-annotations t)
 ;; use normal isearch
 ;;(define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)

 ;; keyboard shortcuts
 (define-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
 (define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
 (define-key pdf-view-mode-map (kbd "D") 'pdf-annot-delete))
(add-hook 'pdf-view-mode-hook 'auto-revert-mode)

(load "local-config")
