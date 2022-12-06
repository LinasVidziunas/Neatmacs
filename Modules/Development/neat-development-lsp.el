;;; neat-development-lsp.el --- Neatmacs Development Configuration --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package pretty-mode
  :hook prog-mode
  :config
  (pretty-deactivate-groups
   '(:equality :ordering :ordering-double :ordering-triple :arrows :arrows-twoheaded :punctuation :logic :sets))
  
  (pretty-activate-groups
   '(:sub-and-superscripts :greek :arithmetic-nary)))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-enable-which-key-integration t)
  (lsp-enable-snippet t)
  (lsp-use-plists t)
  (lsp-idle-delay 0)
  :config
  (customize-set-variable 'read-process-output-max (* 512 1024)))

(use-package lsp-ui
  :after lsp
  :hook lsp-mode
  :custom
  (lsp-ui-doc-position 'bottom)
  :config
  (add-hook 'lsp-ui-imenu-mode (lambda () (display-line-numbers-mode 0))))

(use-package lsp-treemacs
  :after lsp)

(use-package dap-mode
  :hook prog-mode
  :custom
  (dap-auto-configure-features '(sessions locals breakpoints expressions controls tooltip))
  (dap-python-terminal "")
  :commands (dap-mode)
  :config
  (require 'dap-python)
  (require 'dap-hydra)

  ;; automatically trigger the hydra when the program hits a breakpoint
  (add-hook 'dap-stopped-hook
            (lambda () (call-interactively #'dap-hydra))))

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package rainbow-delimiters
  :hook prog-mode)

(use-package flycheck
  :init
  (global-flycheck-mode))

(provide 'neat-development-lsp)
;;; neat-development-lsp.el ends here
