;;; neat-completion.el --- Neatmacs Completion Configuration -*- lexical-binding: t; -*-

;;; Commentary:


;;; Code:

(require 'use-package)

(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify))
(use-package embark
    :bind
    ("C-." . embark-act)
    ("M-." . embark-dwim)
    ("C-h B" . embark-bindings))
(use-package embark-consult
  :after (embark consult)
  :demand t                             ; only necessary if you have the hook below
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key (kbd "M-.")
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<") ;; (kbd "C-+")
  )


(use-package corfu
  :straight (corfu :type git :host github :repo "minad/corfu")
  :custom
  (corfu-cycle t)                       ; Cycling through candidates
  (corfu-auto t)                        ; Auto completion
  (corfu-auto-prefix 2)                 ; Complete with less prefix keys
  (corfu-auto-delay 0.0)                ; No delay for completion
  (corfu-echo-documentation 0.3)        ; Show documentation
  (corfu-popupinfo-delay '(0.3 . 0.15))
  :init
  (global-corfu-mode)
  (corfu-history-mode) 
  (corfu-echo-mode)
  (corfu-popupinfo-mode)
  (corfu-indexed-mode))

(use-package marginalia
  :after vertico
  :bind (:map minibuffer-local-map
	      ("M-A" . marginalia-cycle))
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init (marginalia-mode))

(use-package orderless
  :after vertico
  :init
  (customize-set-variable 'completion-styles '(orderless basic))
  (customize-set-variable 'completion-category-overrides '((file (styles . (partial-completion))))))

(use-package vertico
  :bind (:map minibuffer-local-map
	      ("C-j" . vertico-next)
	      ("C-k" . vertico-previous)
	      :map minibuffer-local-map)
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))


(provide 'neat-completion)
;;; neat-completion.el ends here
