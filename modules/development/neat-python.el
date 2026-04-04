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
;; * anaconda      -- anaconda-mode provides code navigation, documentation lookup and code completion
;; * pyimport      -- pyimport manages Python imports
;; * py-isort      -- Provides commands, which use the external isort tool to tidy up the imports in the current buffer.
;; * blacken       -- buffer formatting on save using black
;;                    (need to pip install black)
;; * numpydoc      -- python doc templates, uses `yasnippets'
;; * pythonic      -- utility packages for running python in different
;;                    environments (dependency of anaconda)
;; * pyvenv        -- virtualenv wrapper
;;
;;; Code:

(require 'neat-development)

(defgroup neatmacs-development-python '()
  "Python development configuration for Neatmacs."
  :tag "Neatmacs Python"
  :group 'neatmacs)

(defvar neatmacs-development-python--required-packages '()
  "Required Python packages for Python development within Emacs"
  )

;; TODO global packages
;; TODO per environment packages

;;================================ LSP ================================

;; TODO: Function to create development venv
;; Install all the required packages for python development

;; anaconda-mode provides code navigation, documentation lookup and code completion
(use-package anaconda-mode
  :hook
  ((python-mode python-ts-mode python-base-mode) . anaconda-mode)
  ((python-mode python-ts-mode python-base-mode) . anaconda-eldoc-mode)
  :custom
  (anaconda-mode-installation-directory
   (expand-file-name "anaconda-mode"
                     (expand-file-name "var" user-emacs-directory)))
  :config
  (add-to-list 'neatmacs-development-python--required-packages 'setuptools))

;; Manages Python import statements
(use-package pyimport
  :config
  (add-to-list 'neatmacs-development-python--required-packages 'pyflakes))

(use-package py-isort
  :config
  (add-to-list 'neatmacs-development-python--required-packages 'isort))

;; TODO
;; Maybe give it a try some day
;; (use-package jedi)

(use-package blacken
  ;; :hook
  ;; ((python-mode python-ts-mode python-base-mode) . blacken-mode)
  :custom
  ;; (blacken-line-length 79)
  (blacken-line-length 120))

(use-package numpydoc
  :custom
  (numpydoc-insert-examples-block nil)
  (numpydoc-template-long nil))

(use-package python
  :straight (:type built-in)
  :custom
  (python-indent-guess-indent-offset nil))

(use-package jupyter)

(use-package flycheck-mypy
  :hook (python-mode . flycheck-mode)
  :after flycheck
  :config
  (add-to-list 'neatmacs-development-python--required-packages 'mypy)
  (add-to-list 'flycheck-disabled-checkers 'python-flake8)
  (add-to-list 'flycheck-disabled-checkers 'python-pylint))

;;======================== Virutal Environment ========================

;; TODO compare against pyvenv
;; TODO challenging to change venv to ./venv-dev
;; (use-package pet
;;   :config
;;   (add-hook 'python-base-mode-hook 'pet-mode -10))

(use-package pyvenv
  :custom
  (pyvenv-default-virtual-env-name "venv")
  :config
  ;; (add-hook 'pyvenv-post-activate-hooks 'eglot-reconnect)
  ;; (add-hook 'pyvenv-post-deactivate-hooks 'eglot-reconnect)

  (pyvenv-mode 1)
  (pyvenv-tracking-mode 1))

(use-package pip-requirements
  :mode ("\\requirements.txt\\'" . pip-requirements-mode))


;; (use-package pippel)

;; TODO: Test how i t works
;; Works well :)
(use-package conda
  :hook
  (conda-postactivate . (lambda () (eglot-reconnect))))


;;============================== Testing ==============================
(use-package pytest
  :bind (:map python-base-mode-map
              ("C-c t a" . pytest-all)
              ("C-c t m" . pytest-module)
              ("C-c t ." . pytest-one)
              ("C-c t c" . pytest-again)
              ("C-c t d" . pytest-directory)
              ("C-c t p a" . pytest-pdb-all)
              ("C-c t p m" . pytest-pdb-module)
              ("C-c t p ." . pytest-pdb-one))
  :custom
  (pytest-cmd-flags '-x -s --color=yes))

(use-package python-pytest)

;; TODO: Compare python-pytest to pytest

;; TODO: Configure to use their python package: cov2emacs
;; Requires theirs pip intall .
;; (use-package pycoverage
;;   :hook ((python-mode python-ts-mode python-base-mode) . pycoverage)
;;   :init
;;   (require 'pyvenv)

;;   (defvar pycoverage--dir
;;     (straight--repos-dir "pycoverage.el"))

;;   (defvar pycoverage--cov2emacs-package-dir
;;     (expand-file-name "cov2emacs" pycoverage--dir))

;;   (defun pycoverage--create-venv ()
;;     (interactive)
;;     (let ((venv-dir (expand-file-name "pycoverage-venv" pycoverage--dir)))

;;       ;; Create venv if it doesn't exist
;;       (when (not (file-exists-p venv-dir))
;;         (shell-command (format "python3 -m venv %s" venv-dir)))

;;       ;; Install cov2emacs package if not in venv/bin
;;       (when (not (file-exists-p (expand-file-name "bin/cov2emacs" venv-dir)))
;;         ;; (shell-command (format "%s/bin/pip install %s" venv-dir "coverage") "*cov2emacs*" "*cov2emacs*")
;;         ;; run command above without blocking emacs. wait to execute next line until done
;;         (start-process-shell-command "cov2emacs" "*cov2emacs*" (format "%s/bin/pip install %s" venv-dir "coverage"))
;;         (shell-command (format "%s/bin/pip install %s" venv-dir pycoverage--cov2emacs-package-dir)))

;;       ;; Update pycoverage to use cov2emacs executable from newly created venv
;;       (customize-set-variable 'pycoverage-cov2emacs-cmd (expand-file-name "bin/cov2emacs" venv-dir)))))


(provide 'neat-python)
;;; neat-python.el ends here
