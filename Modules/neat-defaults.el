;;; neat-defaults.el --- Neatmacs Defaults -*- lexical-binding: t; -*-

;;; Commentary:
;; Sane defaults

;;; Code:

;; Auto revert non file buffers
(customize-set-variable 'global-auto-revert-non-file-buffers t)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Use "y" and "n" to confirm/negate prompt instead of "yes" and "no"
;; Using `advice' here to make it easy to reverse in custom
;; configurations with `(advice-remove 'yes-or-no-p #'y-or-n-p)'
;;
;; N.B. Emacs 28 has a variable for using short answers, which should
;; be preferred if using that version or higher.
(if (boundp 'use-short-answers)
    (customize-set-variable 'use-short-answers t)
  (advice-add 'yes-or-no-p :override #'y-or-n-p))

;; Turn on recentf mode
(add-hook 'after-init-hook #'recentf-mode)
;; (customize-set-variable 'recentf-save-file
;;                         (expand-file-name "recentf" crafted-config-var-directory))

;; Do not save duplicates in kill-ring
(customize-set-variable 'kill-do-not-save-duplicates t)

;; Emacs supports bidirectional editing which means that scripts, such as Arabic, Farsi, and Hebrew,
;; whose natural ordeing is of horizintal text for display is from right to left.
;; Whilst this is a great feature, it adds to the amout of line scans Emacs has to do for rendering
;; text. So we're disabling it.

;; Credits: https://200ok.ch/posts/2020-09-29_comprehensive_guide_on_handling_long_lines_in_emacs.html

(customize-set-variable 'bidi-paragraph-direction 'left-to-right)
(if (version<= "27.1" emacs-version)
    (customize-set-variable 'bidi-inhibit-bpa t))
(if (version<= "27.1" emacs-version)
    (global-so-long-mode 1))

;; Make shebang (#!) file executable when saved
(add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)

;; Enable savehist-mode for command history
(savehist-mode 1)


;; NOTE: If you want to move everything out of the ~/.emacs.d/ folder
;; reliably, set 'user-emacs-directory' before loading no-littering!
;; (setq user-emacs-directory "~/.cache/emacs")
(require 'use-package)
(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

;; Enabling line numbers
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                proced-mode-hook
                vterm-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

(provide 'neat-defaults)
;;; neat-defaults.el ends here
