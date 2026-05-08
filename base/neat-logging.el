;;; neat-logging.el --- Base logging module for Neatmacs -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 Linas Vidziunas
;;
;; Author: Linas Vidziunas <linasvidz@fedora>
;; Maintainer: Linas Vidziunas <linasvidz@fedora>
;; Created: April 03, 2026
;; Modified: May 08, 2026
;; Version: 0.0.1
;; Keywords: internal, lisp
;; Homepage: https://github.com/linasvidz/Neatmacs/base/neat-logging
;; Package-Requires: ((emacs "24.3") (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Base logging facility for Neatmacs modules.
;;  Provides a factory function to generate module-specific loggers.
;;
;;; Code:

(require 'cl-lib)

(defgroup neat-logging nil
  "Internal logging system for Neatmacs."
  :group 'neatmacs)

(defcustom neatmacs-logging-buffer-name "*Neatmacs Logs*"
  "The name of the buffer used for Neatmacs logs.
By convention, Emacs internal buffers start and end with an asterisk."
  :type 'string
  :group 'neat-logging)

(defcustom neatmacs-logging-date-format "%Y-%m-%d %H:%M:%S"
  "Date format for Neatmacs logging, passed to `format-time-string'."
  :type 'string
  :group 'neat-logging)

(defcustom neatmacs-logging-echo-level :info
  "Minimum log level to echo to the `*Messages*` buffer automatically.
Available levels: :debug, :info, :warn, :error."
  :type 'symbol
  :group 'neat-logging)

(defun neat-logging--level-weight (level)
  "Return an integer weight for log LEVEL to allow comparison."
  (cl-case level
    (:debug 0)
    (:info  1)
    (:warn  2)
    (:error 3)
    (t      0)))

(defun neat-logging--write (module level force-echo message-string)
  "Internal function to write MESSAGE-STRING to the log buffer.
Formats output for MODULE and LEVEL. Echoes to `*Messages*` if
FORCE-ECHO is non-nil or if the level meets `neatmacs-logging-echo-level`."
  (let* ((time-str (format-time-string neatmacs-logging-date-format))
         ;; Strip the colon from the keyword (e.g., :info -> INFO)
         (level-str (upcase (substring (symbol-name level) 1)))
         ;; Format: [MODULE: 16 chars] [DATE] | [LEVEL] | MESSAGE
         (log-line (format "[%-16.16s] [%s] | [%-5s] | %s"
                           module time-str level-str message-string))
         (should-echo (or force-echo
                          (>= (neat-logging--level-weight level)
                              (neat-logging--level-weight neatmacs-logging-echo-level)))))

    ;; 1. Echo to *Messages* if threshold is met
    (when should-echo
      (message "[%s] %s: %s" module level-str message-string))

    ;; 2. Write to the dedicated log buffer safely
    (with-current-buffer (get-buffer-create neatmacs-logging-buffer-name)
      (save-excursion
        (goto-char (point-max))
        (let ((start (point)))
          (insert log-line "\n")
          ;; 3. Attach hidden text properties for future filtering capabilities
          (put-text-property start (point) 'neat-log-module module)
          (put-text-property start (point) 'neat-log-level level))))))

;;;###autoload
(defmacro neat-logging-define (func-name module-name)
  "Define a logging function FUNC-NAME for MODULE-NAME.
This generates a callable function so you don't have to use `funcall`.

Usage:
  (neat-logging-define my-log \"ui-module\")
  (my-log :info \"Loaded %d themes\" 5)"
  `(defun ,func-name (level format-string &rest args)
     ;; Dynamically generate a docstring for the new function
     ,(format "Auto-generated logger for the `%s` module." module-name)
     (let ((lvl (if (listp level) (car level) level))
           (force-echo (if (listp level) (cadr level) nil))
           (msg (apply #'format format-string args)))
       (neat-logging--write ,module-name lvl force-echo msg))))

(provide 'neat-logging)
;;; neat-logging.el ends here
