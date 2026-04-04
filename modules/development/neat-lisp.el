;;;; neat-lisp.el --- Lisp development configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration for the Lisp family of languages, including Common
;; Lisp, Clojure, Scheme, and Racket

;;; Code:

;; Global defaults
(require 'eldoc)

;; keeps code indented even when copy/pasting.
(use-package aggressive-indent
  :hook lisp-mode)

;;; Common Lisp
(use-package sly
  :hook (lisp-mode . sly-editing-mode))
(use-package sly-asdf
  :after sly)
(use-package sly-quicklisp
  :after sly)
(use-package sly-repl-ansi-color
  :after sly)

(use-package cider)
(use-package clj-refactor)
(use-package clojure-mode
  :after (cider clj-refactor)
  :config
  (add-hook 'closjure-mode-hook
            (lambda ()
              (clj-refactor-mode 1)
              ;; keybindings mentioned on clj-refactor github page
              ;; conflict with cider, use this by default as it does
              ;; not conflict and is a better mnemonic
              (cljr-add-keybindings-with-prefix "C-c r"))))
(use-package flycheck-clojure)

(use-package aggressive-indent
  :hook
  ((emacs-lisp-mode lisp-mode closjure-mode ) . aggressive-indent-mode))

;; Emacs lisp
(use-package eval-expr)
(use-package eval-sexp-fu)
(use-package suggest)

(provide 'neat-lisp)
;;; neat-lisp.el ends here
