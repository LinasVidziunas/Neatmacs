;;; neat-development.el --- Neatmacs Development Configuration --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package pretty-mode
  :hook prog-mode
  :config
  (pretty-deactivate-groups
   '(:equality :ordering :ordering-double :ordering-triple :arrows :arrows-twoheaded :punctuation :logic :sets))
  
  (pretty-activate-groups
   '(:sub-and-superscripts :greek :arithmetic-nary)))

(use-package eglot
  :hook (prog-mode . eglot-ensure))

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

(provide 'neat-development)
;;; neat-development.el ends here
