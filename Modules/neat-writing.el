;;;; neat-writing.el --- Neatmacs Writing Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Spell checking, ...

;;; Code:

(require 'use-package)

(use-package ispell
  :straight (:type built-in)
  :hook
  (text-mode . flyspell-mode)
  (prog-mode . flyspell-mode)
  :config
  (with-eval-after-load 'corfu
    (add-to-list 'completion-at-point-functions #'cape-ispell)))


(provide 'neat-writing)
;;; neat-writing.el ends here
