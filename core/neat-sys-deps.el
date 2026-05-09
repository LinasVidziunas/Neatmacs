;;; neat-sys-deps.el --- Core ... module for Neatmacs -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 Linas Vidziunas
;;
;; Author: Linas Vidziunas <linasvidz@fedora>
;; Maintainer: Linas Vidziunas <linasvidz@fedora>
;; Created: April 03, 2026
;; Modified: May 08, 2026
;; Version: 0.0.1
;; Keywords: internal, lisp
;; Homepage: https://github.com/linasvidz/Neatmacs/
;; Package-Requires: ((emacs "24.3") (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;  Provides a registry and interactive UI for managing system-level
;;  dependencies required by Emacs packages.
;;
;;
;;; Code:

(require 'cl-lib)
(require 'tabulated-list)
(require 'use-package-core nil t) ; Soft dependency for use-package injection

(defgroup neat-sys-deps nil
  "System dependency management for Neatmacs."
  :group 'neatmacs)

;; TODO use it
(defcustom neat--sys-deps-list-buffer-name "")

;; --- 1. Data Registry ---

(defvar neat-sys-deps--registry (make-hash-table :test 'equal)
  "Hash table storing registered system dependencies.
Keys are dependency names as strings. Values are plists containing
:origin, :version, :description, and :managers.")

(defvar neat-sys-deps-package-managers
  '((apt    . "sudo apt-get install -y %s")
    (dnf    . "sudo dnf install -y %s")
    (pacman . "sudo pacman -S --noconfirm %s")
    (brew   . "brew install %s")
    (npm    . "npm install -g %s"))
  "Alist of supported package managers and their installation command templates.")

(cl-defun neat-sys-deps-register (name &key origin version description managers)
  "Register a system dependency named NAME.
MANAGERS is an alist mapping package manager symbols to their package names.
Example MANAGERS: '((apt . \"ripgrep\") (brew . \"ripgrep\"))"
  (puthash (format "%s" name)
           (list :origin origin
                 :version version
                 :description description
                 :managers managers)
           neat-sys-deps--registry))

;; --- 2. Use-Package Integration ---

(when (featurep 'use-package-core)
  ;; Add :sys-deps to use-package keywords, evaluating just after :if
  (add-to-list 'use-package-keywords :sys-deps t)

  (defun use-package-normalize/:sys-deps (name _keyword args)
    "Normalize the arguments passed to :sys-deps."
    args)

  (defun use-package-handler/:sys-deps (name _keyword args rest state)
    "Handler for the :sys-deps keyword.
Injects registration calls into the package expansion."
    (let ((body (use-package-process-keywords name rest state)))
      (use-package-concat
       ;; Generate a block of code that registers each dependency at load time
       `((dolist (dep ',args)
           (let ((dep-name (car dep))
                 (props (cdr dep)))
             (apply #'neat-sys-deps-register dep-name
                    :origin ',name
                    props))))
       body))))

;; --- 3. UI and Tabulated List Mode ---

(defvar neat-sys-deps-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "m") 'neat-sys-deps-mark)
    (define-key map (kbd "u") 'neat-sys-deps-unmark)
    (define-key map (kbd "x") 'neat-sys-deps-execute)
    (define-key map (kbd "RET") 'neat-sys-deps-describe)
    map)
  "Keymap for `neat-sys-deps-mode`.")

(define-derived-mode neat-sys-deps-mode tabulated-list-mode "SysDeps"
  "Major mode for managing system dependencies in Neatmacs."
  (setq tabulated-list-format
        [("Dependency" 20 t)
         ("Origin" 15 t)
         ("Version" 10 t)
         ("Supported Managers" 30 nil)])
  (setq tabulated-list-padding 2)
  (tabulated-list-init-header))

(defun neat-sys-deps--refresh-entries ()
  "Populate the tabulated list with data from the registry."
  (setq tabulated-list-entries nil)
  (maphash (lambda (name props)
             (let ((origin (symbol-name (or (plist-get props :origin) 'unknown)))
                   (version (or (plist-get props :version) "any"))
                   (managers (plist-get props :managers)))
               (push (list name
                           (vector name origin version
                                   (mapconcat (lambda (m) (symbol-name (car m))) managers ", ")))
                     tabulated-list-entries)))
           neat-sys-deps--registry))

;;;###autoload
(defun neat-sys-deps-list ()
  "Open the Neatmacs system dependencies manager."
  (interactive)
  (let ((buf (get-buffer-create "*Neatmacs System Dependencies*")))
    (with-current-buffer buf
      (neat-sys-deps-mode)
      (neat-sys-deps--refresh-entries)
      (tabulated-list-print))
    (pop-to-buffer buf)))

(provide 'neat-sys-deps)
;;; neat-sys-deps.el ends here
