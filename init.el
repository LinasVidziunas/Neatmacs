;;; init.el -*- lexical-binding: t; -*-

;; Increase the GC threshold for faster starup.
(setq gc-cons-threshold (* 100 1000 1000))

;; Prefer newest compiled .el files
(customize-set-variable 'load-prefer-newer noninteractive)

(when (featurep 'native-compile)
  ;; Silence compiler warnings
  (setq native-comp-async-report-warnings-errors nil)

  ;; Make native compilation happen asynchronously
  (setq native-comp-deferred-compilation t)

  ;; Set the right directory to store the native compilation cache
  ;; Note the method for setting the eln-cache directory depends on the emacs version
  (when (fboundp 'startup-redirect-eln-cache)
    (if (version< emacs-version "29")
        (add-to-list 'native-comp-eln-load-path (convert-standard-filename (expand-file-name "var/eln-cache/" user-emacs-directory)))
      (startup-redirect-eln-cache (convert-standard-filename (expand-file-name "var/eln-cache/" user-emacs-directory)))))
  (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache" user-emacs-directory)))

(load-theme 'deeper-blue t)

(customize-set-variable 'initial-major-mode 'fundamental-mode)

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Neatmacs loaded in %s."
                     (emacs-init-time))))

(set-default-coding-systems 'utf-8)

(customize-set-variable 'large-file-warning-threshold (* 100 1000 1000))

(server-start)

(defgroup neatmacs '()
  "A Neat Emacs Configuration"
  :tag "Neatmacs"
  :group 'emacs)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(setq straight-use-package-by-default t)

(setq package-enable-at-startup nil)

(add-to-list 'load-path (expand-file-name "Modules/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "Modules/Applications" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "Modules/Development" user-emacs-directory))

(when (file-exists-p (expand-file-name "config.el" user-emacs-directory))
  (load (expand-file-name "config.el" user-emacs-directory) nil 'nomessage))
