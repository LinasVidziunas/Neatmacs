;;; neat-modules.el --- Internal module management system -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 Linas Vidziunas
;;
;; Author: Linas Vidziunas <linasvidz@fedora>
;; Maintainer: Linas Vidziunas <linasvidz@fedora>
;; Created: May 08, 2026
;; Modified: May 08, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/linasvidziunas/Neatmacs/
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; Internal module management system for the Neatmacs emacs configuration.
;;
;;; Code:

(require 'neat-logging)

(defvar neat-enabled-flags nil
  "Temporary storage for flags passed to the current module.")

(defun modulep! (flag)
  "Check if FLAG is enabled for the current module context."
  (memq flag neat-enabled-flags))

(defun neat-require (module &rest flags)
  "Search `load-path` for MODULE and load it with optional FLAGS."
  (let* ((start-time (current-time))
         ;; locate-library returns the full path
         (path (locate-library (symbol-name module)))
         (neat-enabled-flags flags))

    (if path
        (progn
          (load path nil 'nomessage)
          (core-log :info
                    (format "Loaded %s %s in %.3fs"
                            (propertize (symbol-name module) 'face 'font-lock-keyword-face)
                            (if flags (propertize (format "%s" flags) 'face 'font-lock-comment-face) "")
                            (float-time (time-since start-time)))))
      (core-log :warn (format "Neatmacs: Could not find module '%s' in load-path" module)))))

(defun module-var! (keyword &optional default)
  "Extract the value associated with KEYWORD from the module arguments.
If KEYWORD is not found, return DEFAULT.
Example: (module-var! :email \"fallback@email.com\")"
  (let ((found (memq keyword neat-enabled-flags)))
    (if found
        (cadr found) ; Grab the item immediately after the keyword
      default)))

(with-eval-after-load 'use-package-core
  ;; 1. Register the new keywords.
  (add-to-list 'use-package-keywords :module-feature)
  (add-to-list 'use-package-keywords :module-var)

  ;; 2. The Normalizers
  (defun use-package-normalize/:module-feature (name keyword args)
    (car args))

  (defun use-package-normalize/:module-var (name keyword args)
    (car args))

  ;; 3. The Handlers with injected debug logs
  (defun use-package-handler/:module-feature (name keyword arg rest state)
    (let ((body (use-package-process-keywords name rest state)))
      ;; Generate an 'if' block instead of 'when' to catch both states at runtime
      `((if (modulep! ,arg)
            (progn
              (core-log :debug "Executing package '%s' -> Feature %s is PRESENT" ',name ,arg)
              ,@body)
          (core-log :debug "Skipping package '%s' -> Feature %s is MISSING" ',name ,arg)))))

  (defun use-package-handler/:module-var (name keyword arg rest state)
    (let ((body (use-package-process-keywords name rest state)))
      `((if (module-var! ,arg)
            (progn
              (core-log :debug "Executing package '%s' -> Variable %s is PRESENT" ',name ,arg)
              ,@body)
          (core-log :debug "Skipping package '%s' -> Variable %s is MISSING" ',name ,arg))))))

(provide 'neat-modules)
