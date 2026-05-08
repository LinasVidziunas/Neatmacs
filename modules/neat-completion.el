;;; neat-completion.el --- Neatmacs Completion Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Module's features. tldr; Enabled with .. in ... Has the following:
;; - vertico-buffer-frame
;; "child frame display for Vertico’s vertico-buffer-mode, with an optional preview child frame"
;; https://github.com/kn66/vertico-buffer-frame


;;; Code:

(require 'use-package)

(defgroup neatmacs-completion nil
  "Neatmacs Completion Configuration"
  :group 'neatmacs
  :prefix "neatmacs-completion-")

;;======================= Minibuffer Completion =======================
(use-package vertico
  :bind (:map minibuffer-local-map
	 ("C-j" . vertico-next)
	 ("C-k" . vertico-previous)
	 :map minibuffer-local-map)
  :custom
  (vertico-scroll-margin 3)
  (vertico-count 10)
  (vertico-resize t)
  (vertico-cycle t)
  :init
  (vertico-mode))

(defun neatmacs-completion--message (message)
  "Display MESSAGE in the echo area."
  :group 'neatmacs-completion
  (message "[NEAT] (Completion) %s" message))

;; Configure directory extension.
(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; Avy-style selection
(use-package vertico-quick
  :ensure nil
  :after vertico
  :config
  (keymap-set vertico-map "M-q" #'vertico-quick-insert)
  (keymap-set vertico-map "C-q" #'vertico-quick-exit))

;;===================== Popup completion framework ====================

;; Corfu completion in minibuffer
(with-eval-after-load 'corfu
  (defun neatmacs-completion--minibuffer-settings ()
    "Local Corfu costumizations for minibuffer completion."
    :group 'neatmacs-completion
    (setq-local corfu-echo-delay nil)) ; Disable automatic echo and popup

  (defun neatmacs-completion--enable-corfu-in-minibuffer ()
    "Enable Corfu in the minibuffer if `completion-at-point' is bound."
    :group 'neatmacs-completion
    (when (where-is-internal #'completion-at-point (list (current-local-map)))
      (neatmacs-completion--minibuffer-settings)
      (corfu-mode 1)))

  (define-minor-mode neatmacs-completion-corfu-in-minibuffer-mode
    "Enable Corfu in the minibuffer."
    :init-value nil
    :global t
    :group 'neatmacs-completion

    (neatmacs-completion--message
     (if neatmacs-completion-corfu-in-minibuffer-mode
         "Enabled Corfu in the minibuffer."
       "Disabled Corfu in the minibuffer."))

    (if neatmacs-completion-corfu-in-minibuffer-mode
        (add-hook 'minibuffer-setup-hook #'neatmacs-completion--enable-corfu-in-minibuffer)
      (remove-hook 'minibuffer-setup-hook #'neatmacs-completion--enable-corfu-in-minibuffer))))

;; TODO: Consider placing it in a better location. This is boarder-line development.
;; Corfu w/ orderless ignore elisp keywords
(with-eval-after-load 'cape
  (defun neatmacs-completion--ignore-elisp-keywords (cand)
    "Ignore elisp keywords in `corfu' completion."
    :group 'neatmacs-completion
    (or (not (keywordp cand))
        (eq (char-after (car completion-in-region--data)) ?:)))


  (defun my/ignore-elisp-keywords (cand)
    (or (not (keywordp cand))
        (eq (char-after (car completion-in-region--data)) ?:)))

  (defun neatmacs-completion-elisp-capfs ()
    "Enable `corfu' completion in `emacs-lisp-mode'."
    (setq-local completion-at-point-functions
                `(,(cape-capf-super
                    (cape-capf-predicate
                     #'elisp-completion-at-point
                     #'neatmacs-completion--ignore-elisp-keywords)
                    #'cape-dabbrev)
                  cape-file)
                cape-dabbrev-min-length 5))

  (add-hook 'emacs-lisp-mode-hook #'neatmacs-completion-elisp-capfs))

(use-package corfu
  :ensure (:host github :repo "minad/corfu" :files ("corfu.el" "extensions/*.el"))
  ;;:straight (corfu :type git :host github :repo "minad/corfu" :files ("corfu.el" "extensions/*.el"))
  :bind
  (:map corfu-map
        ("C-j" . corfu-next)
        ("C-k" . corfu-previous)
        ("M-1" . (lambda () (interactive) (neatmacs-completion-corfu-complete-candidate 1)))
        ("M-g" . (lambda () (interactive) (neatmacs-completion-corfu-complete-candidate 1)))
        ("RET" . nil))
  :custom
  (corfu-on-exact-match nil)              ; Dissable completion on exact match
  (corfu-cycle t)                       ; Cycling through candidates
  (corfu-auto t)                        ; Auto completion
  (corfu-auto-prefix 0)                 ; No need for prefix to suggest
  (corfu-auto-delay 0.0)                ; No delay for completion
  (corfu-echo-documentation 0.3)        ; Show documentation
  (corfu-min-width 35)                  ; Minimum width of the popup window
  (corfu-popupinfo-delay '(0.3 . 0.15))
  (tab-always-indent 'complete)         ; Enable indent and completion using the TAB key
  :init

  (when (version< emacs-version "29")
    ;; Silence the pcomplete capf, no errors or messages!
    (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)

    ;; Ensure that pcomplete does not write to the buffer
    ;; and behaves as a pure `completion-at-point-function'.
    (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify))

  ;; TODO looks like not required anymore
  ;; Compute blended backgrounds correctly when using `kind-icon'
  ;; (with-eval-after-load 'kind-icon
  ;; (kind-icon-default-face 'corfu-default))

  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-echo-mode)
  (corfu-popupinfo-mode)
  (corfu-indexed-mode))

;; Corfu in terminal
(use-package corfu-terminal
  ;;:straight (:type git :repo "https://codeberg.org/akib/emacs-corfu-terminal.git")
  ;;:if (< emacs-version 31)
  :init
  (unless (display-graphic-p)
    (corfu-terminal-mode +1)))


;;=================== Completion at Point Functions ===================
(use-package cape
  :after (corfu)
  :custom
  (cape-dabbrev-check-other-buffers nil)  ; Causes lag when there are a lot of buffers
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-history)
  ;; (add-to-list 'completion-at-point-functions #'cape-keyword)
  ;; (add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;; (add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
  )


;; ;;========================== Some other shit ==========================
;; (use-package embark
;;   :bind
;;   ("C-." . embark-act)
;;   ("M-." . embark-dwim)
;;   ("C-h B" . embark-bindings))

;; (use-package embark-consult
;;   :after (embark consult)
;;   :demand t                             ; only necessary if you have the hook below
;;   :hook
;;   (embark-collect-mode . consult-preview-at-point-mode))

;; (use-package consult
;;   :bind (;; C-c bindings (mode-specific-map)
;;          ("C-c h" . consult-history)
;;          ("C-c m" . consult-mode-command)
;;          ("C-c k" . consult-kmacro)
;;          ;; C-x bindings (ctl-x-map)
;;          ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
;;          ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
;;          ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
;;          ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
;;          ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
;;          ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
;;          ;; Custom M-# bindings for fast register access
;;          ("M-#" . consult-register-load)
;;          ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
;;          ("C-M-#" . consult-register)
;;          ;; Other custom bindings
;;          ("M-y" . consult-yank-pop)                ;; orig. yank-pop
;;          ("<help> a" . consult-apropos)            ;; orig. apropos-command
;;          ;; M-g bindings (goto-map)
;;          ("M-g e" . consult-compile-error)
;;          ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
;;          ("M-g g" . consult-goto-line)             ;; orig. goto-line
;;          ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
;;          ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
;;          ("M-g m" . consult-mark)
;;          ("M-g k" . consult-global-mark)
;;          ("M-g i" . consult-imenu)
;;          ("M-g I" . consult-imenu-multi)
;;          ;; M-s bindings (search-map)
;;          ("M-s d" . consult-find)
;;          ("M-s D" . consult-locate)
;;          ("M-s g" . consult-grep)
;;          ("M-s G" . consult-git-grep)
;;          ("M-s r" . consult-ripgrep)
;;          ("M-s l" . consult-line)
;;          ("M-s L" . consult-line-multi)
;;          ("M-s m" . consult-multi-occur)
;;          ("M-s k" . consult-keep-lines)
;;          ("M-s u" . consult-focus-lines)
;;          ;; Isearch integration
;;          ("M-s e" . consult-isearch-history)
;;          :map isearch-mode-map
;;          ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
;;          ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
;;          ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
;;          ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
;;          ;; Minibuffer history
;;          :map minibuffer-local-map
;;          ("M-s" . consult-history)                 ;; orig. next-matching-history-element
;;          ("M-r" . consult-history))                ;; orig. previous-matching-history-element

;;   :hook (completion-list-mode . consult-preview-at-point-mode)
;;   :init
;;   (setq register-preview-delay 0.5
;;         register-preview-function #'consult-register-format)
;;   (advice-add #'register-preview :override #'consult-register-window)
;;   (setq xref-show-xrefs-function #'consult-xref
;;         xref-show-definitions-function #'consult-xref)
;;   :config
;;   (consult-customize
;;    consult-theme :preview-key '(:debounce 0.2 any)
;;    consult-ripgrep consult-git-grep consult-grep
;;    consult-bookmark consult-recent-file consult-xref
;;    consult--source-bookmark consult--source-file-register
;;    consult--source-recent-file consult--source-project-recent-file
;;    ;; :preview-key (kbd "M-.")
;;    :preview-key '(:debounce 0.4 any))
;;   (setq consult-narrow-key "<") ;; (kbd "C-+")
;;   )

(use-package emacs
  :ensure nil
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our Vertico's settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

(use-package marginalia
  ;;:hook (elpaca-after-init . marginalia-mode)
  ;; :bind (:map minibuffer-local-map
  ;;         ("M-m" . marginalia-cycle))
  ;; :custom
  ;; (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :after vertico
  :config
  (setf (alist-get 'elpaca-info marginalia-command-categories) 'elpaca)
  (marginalia-mode))

(require 'neat-modules)

(when (modulep! '+vertico-buffer-frame)
  (use-package vertico-buffer-frame
    :after vertico
    :ensure (:host github :repo "kn66/vertico-buffer-frame")
    :bind
    (:map vertico-map
          ("C-t" . vertico-buffer-frame-toggle-preview))
    :hook (elpaca-after-init . (lambda ()
                                 (vertico-buffer-mode 1)
                                 (vertico-buffer-frame-mode 1)))
    :custom
    (vertico-buffer-frame-preview t)
    (vertico-buffer-frame-preview-layout 'overlay)
    (vertico-buffer-frame-preview-delay 0.2)
    (vertico-buffer-frame-preview-io-timeout 0.3)
    (vertico-buffer-frame-golden-ratio-scale 1.00)))

(when (modulep! '+icons)
  (use-package all-the-icons)

  (use-package all-the-icons-completion
    :after (marginalia all-the-icons)
    :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
    :init
    (all-the-icons-completion-mode)))

(provide 'neat-completion)
;;; neat-completion.el ends here
