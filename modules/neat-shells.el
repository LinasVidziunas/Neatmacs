;;;; neat-shells.el --- Shell-pop configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration for the Lisp family of languages, including Common
;; Lisp, Clojure, Scheme, and Racket

;;; Code:

(defgroup neatmacs-shells '()
  "Shell related configuration for Neatmacs."
  :tag "Neatmacs Shells"
  :group 'neatmacs)

(defcustom neatmacs-shell "bash"
  ""
  :group 'neatmacs-shells
  :type 'string)

;; ================================ Term ===============================

(use-package term
  :straight (:type built-in)
  :commands term
  :custom
  (term-buffer-maximum-size 10000)
  (explicit-shell-file-name neatmacs-shell)
  (term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))


;; =============================== Eshell ==============================

(use-package eshell
  :straight (:type built-in)
  :custom
  (eshell-history-size 10000)
  (eshell-buffer-maximum-lines 10000)
  (eshell-scroll-to-bottom-on-input t)
  (eshell-banner-message "")             ; Suppress the startup message
  :config
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  (with-eval-after-load 'esh-opt
    (customize-set-variable 'eshell-destroy-buffer-when-process-dies t)
    (customize-set-variable 'eshell-visual-commands '("top" "htop" "vim" "nvim" "nano"))))

;; Provides syntax highlighting for eshell.
;; It highlightings the user commands at the interactive prompt to provide feedback on the validity of the commands and syntax.
(use-package eshell-syntax-highlighting
  :after eshell-mode
  :ensure t ;; Install if not already installed.
  :custom
  (eshell-syntax-highlighting-highlight-in-remote-dirs nil) ;; Disable highlighting in remote directories due to high-latency TRAMP connections.
  :config
  ;; Enable in all Eshell buffers.
  (eshell-syntax-highlighting-global-mode +1))


;; Provides themes for Emacs Shell (Eshell) prompt.
;; TODO remove due to not being very reliable and not being updated
;; (use-package eshell-git-prompt)

;; And use instead the following
(use-package eshell-prompt-extras
  :config
  (with-eval-after-load 'esh-opt
    (autoload 'epe-theme-dakrone "eshell-prompt-extras")
    (setq eshell-highlight-prompt nil
          eshell-prompt-function 'epe-theme-dakrone)))

;; =============================== Others ==============================

(use-package vterm
  :commands vterm
  :custom
  (vterm-shell neatmacs-shell)
  (vterm-max-scrollback 10000))


;; TODO: Figure out if working at all
(use-package pcmpl-args)

;; TODO figure out if it is useful
;; TODO may want to consider using this with shell-pop
(use-package eat
  :after eshell
  :straight (eat :type git
                 :host codeberg
                 :repo "akib/emacs-eat"
                 :files ("*.el" ("term" "term/*.el") "*.texi"
                         "*.ti" ("terminfo/e" "terminfo/e/*")
                         ("terminfo/65" "terminfo/65/*")
                         ("integration" "integration/*")
                         (:exclude ".dir-locals.el" "*-tests.el")))
  :config
  (add-hook 'eshell-load-hook #'eat-eshell-mode))

(use-package shell-pop
  :after (eat eshell)
  :bind (("C-c s" . shell-pop)
         ("C-c S" . shell-pop-project-root))

  :commands shell-pop
  :custom
  (shell-pop-default-directory nil) ; cd to the current directory
  (shell-pop-shell-type (quote ("term" "*term*" (lambda nil (eshell shell-pop-term-shell)))))
  (shell-pop-term-shell neatmacs-shell)
  (shell-pop-universal-key "C-c s")
  (shell-pop-window-size 25)
  (shell-pop-full-span t)
  (shell-pop-window-positioning "bottom")
  (shell-pop-autocd-to-working-dir t)
  (shell-pop-restore-window-configuration t)
  (shell-pop-cleanup-buffer-at-process-exit t)

  :config

  (require 'project)

  (defun shell-pop-project-root ()
    "Open a shell in the project root."
    (let ((shell-pop-default-directory (project-root (project-current t)))
          (shell-pop-autocd-to-working-dir nil))
      (message "Project root: %s" shell-pop-default-directory)
      (if shell-pop-default-directory
          (shell-pop shell-pop-default-directory)
        (message "Not in a project.")))))



;; (use-package shell-pop
;;   :after (vterm)
;;   :custom
;;   (shell-pop-default-directory nil) ; cd to the current directory
;;   (shell-pop-shell-type (quote ("term" "*term*" (lambda nil (vterm shell-pop-term-shell)))))
;;   (shell-pop-term-shell neatmacs-shell)
;;   (shell-pop-universal-key "C-c s")
;;   (shell-pop-window-size 25)
;;   (shell-pop-full-span t)
;;   (shell-pop-window-positioning "bottom")
;;   (shell-pop-autocd-to-working-dir t)
;;   (shell-pop-restore-window-configuration t)
;;   (shell-pop-cleanup-buffer-at-process-exit t))


(provide 'neat-shells)
;;; neat-shells.el ends here
