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

(defvar neat-modules-dir (expand-file-name "modules/" user-emacs-directory)
  "The directory where module files are stored.")

(defun modulep! (flag)
  "Check if FLAG is enabled for the current module context."
  (memq flag neat-enabled-flags))

(defun neat-require (module &rest flags)
  "Load a module from `neat-modules-dir` with optional FLAGS.
Example: (neat-require 'neat-ui '+icons '+extra)"
  (let* ((start-time (current-time))
         (filename (format "%s.el" module))
         (path (expand-file-name filename neat-modules-dir))
         ;; Local binding so flags don't leak between different module loads
         (neat-enabled-flags flags))

    (if (file-exists-p path)
        (progn
          (load path nil 'nomessage)
          (base-log :info
                    (format "Loaded %s %s in %.3fs"
                            (propertize (symbol-name module) 'face 'font-lock-keyword-face)
                            (if flags (propertize (format "%s" flags) 'face 'font-lock-comment-face) "")
                            (float-time (time-since start-time)))))
      (base-log :warn "Neatmacs: Could not find module file %s" path))))

(provide 'neat-modules)
