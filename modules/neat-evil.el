;;; neat-evil.el --- Evil Keybindingsconfiguration -*- lexical-binding: t; -*-

;;; Commentary:

;; Evil mode configuration

;;; Code:

(require 'use-package)

(use-package evil
  :init
  (evil-mode 1)
  :custom
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-want-C-i-jump nil)
  (evil-undo-system 'undo-redo)
  :config
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'message-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :init
  (evil-collection-init))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))


;;; Per package evil keybindings
;;; - dired-single
(with-eval-after-load 'dired-single
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

;;; - dired-hide-dotfiles
(with-eval-after-load 'dired-hide-dotfiles
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

;;; - treemacs
(use-package treemacs-evil
  :after treemacs evil
  :config
  (evil-treemacs-state t))

(provide 'neat-evil)
;;; neat-evil.el ends here
