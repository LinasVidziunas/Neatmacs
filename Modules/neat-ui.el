;;; neat-ui.el --- Neatmacs UI Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Packages:
;; - all-the-icons
;; - doom-themes
;; - doom-modeline
;; - which-key
;; - helpful
;; - elisp-demos
;; - solaire

;;; Code:

;;; Sane defaults
(customize-set-variable 'inhibit-startup-message t)
(customize-set-variable 'visible-bell t)

(scroll-bar-mode -1)			; Disable visible scrollbar
(tool-bar-mode -1)			; Disable the toolbar
(menu-bar-mode -1)			; Disable te menu bar
(tooltip-mode -1)			; Disable tooltips
(set-fringe-mode 10)			; Give some breathing room

(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; Make ESC quit prompts

;;; Font
(defgroup neatmacs-ui '()
  "User interface related configuration for Neatmacs."
  :tag "Neat UI"
  :group 'neatmacs)

;;; Line Numbers

;;; Packages:

(require 'use-package)

(use-package all-the-icons
  :init
  (unless (member "all-the-icons" (font-family-list))
    (all-the-icons-install fonts t))
  :custom
  (all-the-icons-scale-factor 1))


(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  (doom-themes-treemacs-theme "doom-atom")
  :config
  (doom-themes-treemacs-config)
  (doom-themes-org-config)
  :init
  ;; Disable temporary theme which prevents blindness on startup.
  (disable-theme 'deeper-blue)
  (load-theme 'doom-henna t))

(use-package doom-modeline
  :custom
  (doom-modeline-height 15)
  :init
  (doom-modeline-mode 1))

(use-package which-key
  :defer t
  :diminish which-key-mode
  :custom
  (which-key-idle-delay 0.4)
  :init
  (which-key-mode))

(use-package helpful
  :bind
  ("C-h f" . helpful-callable)
  ("C-h v" . helpful-variable)
  ("C-h k" . helpful-key)

  ;; Lookup the current symbol at point. C-c C-d is a common keybinding
  ;; for this in lisp modes.
  ("C-c C-d" . helpful-at-point)

  ;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
  ;; already links to the manual, if a function is referenced there.
  ("C-h F" . helpful-function)

  ;; By default, C-h C is bound to describe `describe-coding-system'. I
  ;; don't find this very useful, but it's frequently useful to only
  ;; look at interactive functions.
  ("C-h C" . helpful-command)
  :commands (helpful-callable helpful-function helpful-variable helpful-at-point helpful-command helpful-key)
  :custom (helpful-max-buffers 1))


;;; Elisp-demos
;; Provides Elisp API demos in help buffers
(use-package elisp-demos
  :after helpful
  :config
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))


;;; Solaire-mode
;; is an aesthetic plugin designed to visually distinguish "real" buffers
;; (i.e file-visiting code buffers where you do most of your work)
;; from "unreal" buffers (like popups, sidebars, log buffers, terminals)
;; by giving the latter a slightly different color.
(use-package solaire-mode
  :config
  (solaire-global-mode +1))

(use-package hydra)

(provide 'neat-ui)
;;; neat-ui.el ends here
