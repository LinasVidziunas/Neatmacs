;;;; neat-eshell.el --- Eshell configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration for the Lisp family of languages, including Common
;; Lisp, Clojure, Scheme, and Racket

;;; Code:

;; Global defaults
(require 'eshell)
(require 'term)

;; Save command history when commands are entered
(add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

(with-eval-after-load 'esh-opt
  (setq eshell-destroy-buffer-when-process-dies t)
  (setq eshell-visual-commands '("htop" "vim" "nvim" "nano")))

(use-package ehs

(eshell-git-prompt-use-theme 'powerline)

(provide 'neat-eshell)
;;; neat-eshell.el ends here
