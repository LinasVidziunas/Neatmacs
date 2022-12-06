;;;; neat-pass.el --- GNU Pass Configuration -*- lexical-binding: t; -*-

;;; Commentary:

;; Prerequisites:
;; - Pass

;;; Code:

(require 'auth-source)
(customize-set-variable 'auth-source-pass-filename "~/.password-store")

(use-package pass)

(provide 'neat-pass)
;;; neat-pass.el ends here
