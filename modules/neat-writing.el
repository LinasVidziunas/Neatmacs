;;;; neat-writing.el --- Neatmacs Writing Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; - Spell checking using ispell.
;;     - Requires ispell
;;
;;
;; - Spell checking using Jinx
;;     - Requires enchant2 and pkgconfig
;;

;;; Code:

(require 'use-package)

(use-package jinx
  :hook ((text-mode . jinx-mode)
         (prog-mode . jinx-mode)
         (conf-mode . jinx-mode))
  :bind ([remap ispell-word] . jinx-correct))

(use-package ispell
  :straight (:type built-in)
  :config
  (with-eval-after-load 'corfu
    (add-to-list 'completion-at-point-functions #'cape-dict)))

(use-package writegood-mode
  :hook (org-mode))

;; (use-package flymake-grammarly
;;   :hook ((org-mode . flymake-grammarly-load)
;;          (text-mode . flymake-grammarly-load))
;;   :custom flymake-grammarly-check-time 0.8)

;; (use-package eglot-grammarly
;;   :straight (:host github :repo "emacs-grammarly/eglot-grammarly")
;;   :defer t ; defer package loading
;;   :hook ((text-mode markdown-mode org-mode) . (lambda ()
;;                                                 (require 'eglot-grammarly)
;;                                                 (eglot-ensure))))

(provide 'neat-writing)
;;; neat-writing.el ends here
