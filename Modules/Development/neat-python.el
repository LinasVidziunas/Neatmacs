;;;; neat-python.el --- Pyton development configuration -*- lexical-binding: t; -*-
;;
;;; Commentary:
;;
;; Python development environment configuration.  Several python packages
;; can be installed with 'pip'.  Many of these are needed by the Emacs
;; packages used in this configuration
;;
;; * autopep8      -- automatically formats python code to conform to PEP 8 style guide
;; * black         -- uncompromising code formatter
;; * flake8        -- style guide enforcement
;; * importmagic   -- automatically add, remove, manage imports
;; * ipython       -- interactive python shell
;; * yapf          -- formatter for python code

;; Emacs packages to support python development:
;; * anaconda      -- code navigation, documentation and completion
;; * blacken       -- buffer formatting on save using black
;;                    (need to pip install black)
;; * lsp-pyright   -- language server integration
;;                    (need to pip install pyright)
;; * numpydoc      -- python doc templates, uses `yasnippets'
;; * pythonic      -- utility packages for running python in different
;;                    environments (dependency of anaconda)
;; * pyvenv        -- virtualenv wrapper
;;
;;; Code:

(require 'neat-development)

(use-package anaconda-mode
  :hook python-mode
  :custom
  (anaconda-mode-installation-directory
   (expand-file-name "anaconda-mode"
                     (expand-file-name "var" user-emacs-directory))))

(use-package blacken
  :hook python-mode)

(use-package numpydoc
  :custom
  (numpydoc-insert-examples-block nil)
  (numpydoc-template-long nil))

(use-package pyvenv
  :hook
  (python-mode . pyvenv-mode)
  (python-mode . pyvenv-tracking-mode)
  :custom
  (pyvenv-default-virtual-env-name "venv")
  :config
  (add-hook 'pyvenv-post-activate-hooks #'pyvenv-restart-python))

(use-package python
  :straight (:type built-in)
  :custom
  (python-indent-guess-indent-offset nil))

(provide 'neat-python)
;;; lisp.el ends here
