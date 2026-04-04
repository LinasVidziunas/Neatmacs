;;; init.el -*- lexical-binding: t; -*-

(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "var/elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                       :ref nil :depth 1 :inherit ignore
                       :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                       :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Uncomment for systems which cannot create symlinks:
;; (elpaca-no-symlink-mode)

;; Install use-package support
(elpaca elpaca-use-package
        ;; Enable use-package :ensure support for Elpaca.
        (elpaca-use-package-mode))

;;Turns off elpaca-use-package-mode current declaration
;;Note this will cause evaluate the declaration immediately. It is not deferred.
;;Useful for configuring built-in emacs features.
(use-package emacs :ensure nil :config (setq ring-bell-function #'ignore))

(setq use-package-always-ensure t)

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Neatmacs loaded in %s."
                     (emacs-init-time))))

;;; Set default coding system
(set-default-coding-systems 'utf-8)
;;; Warn about opening files more than 100MB in size
(customize-set-variable 'large-file-warning-threshold (* 100 1000 1000))

(defgroup neatmacs '()
  "A Neat Emacs Configuration"
  :tag "Neatmacs"
  :group 'emacs)

(defvar neatmacs-config-file (expand-file-name "config.el" user-emacs-directory)
  "User's Neatmacs configuration file.")

(defvar neatmacs-load-custom-file t
  "Whether to load `custom.el` or not. When non-nil, `custom.el` is loaded after `config.el`")

(setq package-enable-at-startup nil)

;;; Add Modules to load path
(add-to-list 'load-path (expand-file-name "modules/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "modules/applications" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "modules/development" user-emacs-directory))

;;; Load user configuration
(when (file-exists-p neatmacs-config-file)
  (load neatmacs-config-file nil 'nomessage))

;;; Use a customization file to store values instead of init.el
(customize-set-variable 'custom-file
                        (expand-file-name "custom.el" user-emacs-directory))
(add-hook 'elpaca-after-init-hook
          (lambda ()
            (when neatmacs-load-custom-file
              (load custom-file 'noerror))))

;;; Decrease garbage collection threshold
(setq gc-cons-threshold (* 80 1000 1000))


;; Local Variables:
;; no-byte-compile: t
;; no-native-compile: t
;; no-update-autoloads: t
;; End:
