;;;; neat-file-management.el --- Neatmacs File Management Configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'use-package)

(use-package dired
  :straight (:type built-in)
  :commands (dired dired-jump)
  :bind
  ("C-x C-j" . dired-jump)
  :custom
  (dired-listing-switches "-agho --group-directories-first"))

(use-package dired-single
  :config
  (define-key dired-mode-map [remap dired-find-file]
    'dired-single-buffer)
  (define-key dired-mode-map [remap dired-mouse-find-file-other-window]
    'dired-single-buffer-mouse)
  (define-key dired-mode-map [remap dired-up-directory]
    'dired-single-up-directory))

(use-package dired-hide-dotfiles
  :after dired
  :hook dired-mode)

(use-package treemacs
  :commands treemacs
  :custom
  (treemacs-width 30))

(provide 'neat-file-management)
;;; neat-file-management.el ends here
