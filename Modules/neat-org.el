;;;; neat-org.el --- Neatmacs Org Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration for the Lisp family of languages, including Common
;; Lisp, Clojure, Scheme, and Racket

;;; Code:

(require 'use-package)

(use-package org
  :straight (:type built-in)
  :config
  (require 'org-tempo)

  ;; Structure templates
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))

  ;; Babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (python . t)
     (latex . t))))

(use-package org-modern
  :after org
  :config
  (global-org-modern-mode))

;; Org babel asynchronous execution
(use-package ob-async
  :after org ob
  :custom
  ;; Disable asynchronous for the following languages
  (ob-async-no-async-languages-alist '("ipython")))

(provide 'neat-org)
;;; neat-org.el ends here
