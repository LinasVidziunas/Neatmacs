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
         ;; locate-library returns the full path (e.g., .../modules/development/neat-python.el)
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

(provide 'neat-modules)
