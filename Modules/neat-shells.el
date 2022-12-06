;;;; neat-shells.el --- Shell-pop configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration for the Lisp family of languages, including Common
;; Lisp, Clojure, Scheme, and Racket

;;; Code:

(require 'term)
(require 'eshell)

(defgroup neatmacs-shells '()
  "Shell related configuration for Neatmacs."
 :tag "Neatmacs Shells"
 :group 'neatmacs)

(defcustom neatmacs-shell "bash"
  ""
  :group 'neatmacs-shells
  :type 'string)

(customize-set-variable 'term-buffer-maximum-size 10000)
(customize-set-variable 'explicit-shell-file-name neatmacs-shell)
(customize-set-variable 'term-prompt-regexp "^[^#$%>\n]*[#$%>] *")

;;; Eshell
;; Save command history when commands are entered
(add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

(customize-set-variable 'eshell-history-size 10000)
(customize-set-variable 'eshell-buffer-maximum-lines 10000)
(customize-set-variable 'eshell-scroll-to-bottom-on-input t)

(with-eval-after-load 'esh-opt
  (customize-set-variable 'eshell-destroy-buffer-when-process-dies t)
  (customize-set-variable 'eshell-visual-commands '("top" "htop" "vim" "nvim" "nano")))

(use-package vterm
  :commands vterm
  :custom
  (vterm-shell neatmacs-shell)
  (vterm-max-scrollback 10000))

(use-package shell-pop
  ;; :bind ("C-c s" . shell-pop)
  :custom
  (shell-pop-default-directory nil) ; cd to the current directory
  (shell-pop-shell-type (quote ("term" "*term*" (lambda nil (vterm shell-pop-term-shell)))))
  (shell-pop-term-shell neatmacs-shell)
  (shell-pop-universal-key "C-c s")
  (shell-pop-window-size 25)
  (shell-pop-full-span t)
  (shell-pop-window-positioning "bottom")
  (shell-pop-autocd-to-working-dir t)
  (shell-pop-restore-window-configuration t)
  (shell-pop-cleanup-buffer-at-process-exit t))

(provide 'neat-shells)
;;; neat-shells.el ends here
