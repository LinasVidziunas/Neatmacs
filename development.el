(use-package pretty-mode
  :hook (prog-mode . pretty-mode) ;; For all programming modes
  :config
    (pretty-deactivate-groups
      '(:equality :ordering :ordering-double :ordering-triple
        :arrows :arrows-twoheaded :punctuation
        :logic :sets))

    (pretty-activate-groups
      '(:sub-and-superscripts :greek :arithmetic-nary)))

(defun linas/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
  (lsp-mode . linas/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l") ; Or 'C-l', 's-l'
  (setq read-process-output-max (* 512 1024))
  :custom
  (lsp-enable-snippet nil)
  (lsp-use-plists t)
  (lsp-idle-delay 0.100)
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom (lsp-ui-doc-position 'bottom )
  :config
  (add-hook 'lsp-ui-imenu-mode-hook (lambda() (display-line-numbers-mode 0)))) ;;; No line numbers

(use-package lsp-treemacs
  :after lsp)

(use-package dap-mode
  :hook (python-mode . dap-mode)
  :custom
  (dap-auto-configure-features '(sessions locals breakpoints expressions controls tooltip))
  (dap-python-terminal "")
  :commands (dap-mode)
  :config
  (require 'dap-python)
  (require 'dap-hydra)

  ;; automatically trigger the hydra when the program
  ;; hits a breakpoint by using the following code.
  (add-hook 'dap-stopped-hook
            (lambda (arg) (call-interactively #'dap-hydra))))

(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection)
              :map lsp-mode-map
              ("<tab>" . company-indent-or-complete-common))
  :custom
  (add-to-list 'company-backends 'company-ispell)
  (company-ispell-dictionary ispell-dictionary)
  (company-selection-wrap-around t)
  (company-show-numbers t)
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.15))

(use-package company-box
  :hook (company-mode . company-box-mode)
  :custom (company-box-doc-delay 0.3))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  ;; :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package magit
  ;; Might want to comment out custom later
  :commands magit-status
  :custom (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package forge
  :after magit)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package emmet-mode
  :config
  (add-hook 'web-mode-hook 'emmet-mode)
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'html-mode-hook 'emmet-mode)
  (add-hook 'css-mode-hook 'emmet-mode))

(use-package lsp-pyright
  :after (lsp-deferred)
  :custom
  (lsp-pyright-typechecking-mode "strict")
  (lsp-pyright-diagnostic-mode "workspace")
  (lsp-pyright-use-library-code-for-types t)
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred))))

;; (use-package typescript-mode
;;   :mode "\\.ts\\'"
;;   :hook (typescript-mode . lsp-deferred)
;;   :config
;;   (setq typescript-indent-level 2)
;;   (require 'dap-mode)
;;   (dap-node-setup))

(use-package js2-mode
  :mode "\\.js\\'"
  :hook (javascript-mode . lsp-deferred))

(use-package vue-mode
  :hook (vue-mode . lsp-deferred))

(use-package vue-html-mode
  :hook (vue-html-mode . lsp-deferred))

(use-package csharp-mode
  :mode "\\.cs\\'"
  :config
  (add-hook 'csharp-mode-hook 'lsp-deferred))

(use-package go-mode
  :mode "\\.go\\'"
  :hook (go-mode . lsp-deferred))

(use-package lsp-java
  :custom
  (lsp-java-java-path "/usr/lib/jvm/jre-11/bin/java"))

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (C .t)
     (shell . t)
     (latex . t)
     (python . t)))
  (push '("conf-unix" . conf-unix) org-src-lang-modes))

;; Don't ask if you are sure to evaluate
(setq org-confirm-babel-evaluate nil)

(use-package flycheck
  :init
  (global-flycheck-mode))

(use-package multiple-cursors)

(use-package flymake-shellcheck
  :commands flymake-shellcheck-load
  :init
  (add-hook 'sh-mode-hook 'flymake-shellcheck-load))
