;;;; neat-file-management.el --- Neatmacs File Management Configuration -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'use-package)

(use-package dired
  :straight (:type built-in)
  :commands (dired dired-jump)
  :custom
  (dired-listing-switches "-ahl --group-directories-first")
  (dired-omit-files "\\.[^.].*")
  (dired-omit-verbose nil)
  (delete-by-moving-to-trash t)         ; Use system's trashcan
  :bind
  ("C-x C-j" . dired-jump))
  ;; :custom
  ;; :config
  ;; (when (string= system-type "darwin")
    ;; (setq dired-use-ls-dired nil)))

(use-package dired-single
  :config
  (define-key dired-mode-map [remap dired-find-file]
    'dired-single-buffer)
  (define-key dired-mode-map [remap dired-mouse-find-file-other-window]
    'dired-single-buffer-mouse)
  (define-key dired-mode-map [remap dired-up-directory]
    'dired-single-up-directory))

;; (use-package dired-hide-dotfiles
;;   :after dired
;;   :hook dired-mode)

;; (use-package dirvish
;;   :config
;;   (dirvish-override-dired-mode))

(use-package treemacs
  :bind ("C-c t" . treemacs)
  :commands treemacs
  :custom
  (treemacs-width 40)
  :config

  ;; treemacs-resize-icons requires Emacs >= 27.1 or ImageMagick
  (when (or (fboundp 'imagemagick-types) (>= emacs-major-version 27.1))
    (treemacs-resize-icons 18)))

(provide 'neat-file-management)
;;; neat-file-management.el ends here
