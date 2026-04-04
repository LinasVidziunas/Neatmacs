;;; neat-defaults.el --- Neatmacs Defaults -*- lexical-binding: t; -*-

;;; Commentary:
;; Sane defaults

;;; Code:

(require 'use-package)

(use-package emacs
  :ensure nil
  :custom
  ;; Emacs supports bidirectional editing which means that scripts, such as Arabic, Farsi,
  ;; and Hebrew, whose natural ordeing is of horizintal text for display is from right to
  ;; left. Whilst this is a great feature, it adds to the amout of line scans Emacs has to
  ;; do for rendering text. So we're disabling it.
  ;; Credits: https://200ok.ch/posts/2020-09-29_comprehensive_guide_on_handling_long_lines_in_emacs.html
  (bidi-paragraph-direction 'left-to-right)

  ;; Increase undo limits
  (undo-limit (* 100 1000 1000))
  (undo-strong-limit (* 200 1000 1000))
  (undo-outer-limit (* 2000 1000 1000))

  ;; Sentences do not need double spaces to end.
  (sentence-end-double-space nil)
  :config
  (if (version<= "27.1" emacs-version)
    (customize-set-variable 'bidi-inhibit-bpa t)))


;; Revert buffers when the underlying file has changed
(use-package autorevert
  :hook (after-init . global-auto-revert-mode)
  :ensure nil

  :custom
  ;; Enable 'global-auto-revert-mode' to revert buffers with a custom
  ;; ‘revert-buffer-function’ and a ‘buffer-stale-function’ function.
  ;; E.g. dired.
  (global-auto-revert-non-file-buffers t)

  ;; Decrease revert interval to 1s from 5s.
  (auto-revert-interval 1))

(use-package recentf
  :ensure nil
  :after no-littering
  :hook (after-init . recentf-mode)
  :config
  (add-to-list 'recentf-exclude
               (recentf-expand-file-name no-littering-var-directory))
  (add-to-list 'recentf-exclude
               (recentf-expand-file-name no-littering-etc-directory)))


(use-package simple
  :ensure nil
  :custom
  ;; Do not save duplicates in kill-ring
  (kill-do-not-save-duplicates t)

  ;; Use spaces instead of tabs
  (indent-tabs-mode nil))

(if (version<= "27.1" emacs-version)
    (global-so-long-mode 1))

;; Enable savehist-mode for command history
(savehist-mode 1)



(use-package no-littering
  :config
  ;;; Auto-save, backup, and undo-tree files
  ;; Increases odds that sensitive informaiton is written to disk.
  ;; Read more at:
  ;; https://github.com/emacscollective/no-littering?tab=readme-ov-file#suggested-settings
  (no-littering-theme-backups)

  ;;; Lock files
  ;; C-h f `lock-file-name-transforms' for reasons why you might want to refrain from
  ;; doing this.
  (let ((dir (no-littering-expand-var-file-name "lock-files/")))
    (make-directory dir t)
    (setq lock-file-name-transforms `((".*" ,dir t)))))



;; Enabling line numbers
(column-number-mode)

;; (if (version<= "26.0" emacs-version)
;;     (global-display-line-numbers-mode t))

;; ;; Disable line numbers for some modes
;; (dolist (mode '(org-mode-hook
;;                 term-mode-hook
;;                 shell-mode-hook
;;                 treemacs-mode-hook
;;                 proced-mode-hook
;;                 vterm-mode-hook
;;                 eshell-mode-hook))
;;   (add-hook mode (lambda() (display-line-numbers-mode 0))))


(use-package files
  :ensure nil
  :custom
  ;; Always end a file with a newline.
  (require-final-newline t))

;; Use "y" and "n" to confirm/negate prompt instead of "yes" and "no"
;; Using `advice' here to make it easy to reverse in custom
;; configurations with `(advice-remove 'yes-or-no-p #'y-or-n-p)'
;;
;; N.B. Emacs 28 has a variable for using short answers, which should
;; be preferred if using that version or higher.
(if (boundp 'use-short-answers)
    (customize-set-variable 'use-short-answers t)
  (advice-add 'yes-or-no-p :override #'y-or-n-p))


(provide 'neat-defaults)
;;; neat-defaults.el ends here
