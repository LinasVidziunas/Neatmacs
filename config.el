;;; config.el --- User configuration for Neatmacs -*- lexical-binding: t; -*-

;;; Commentary:
;; Loading modules, and other user-written code
;; 
;;; Code:

;;; Add Modules to load path
(add-to-list 'load-path (expand-file-name "Modules/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "Modules/Applications" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "Modules/Development" user-emacs-directory))

;;; Modules

(require 'neat-defaults)                ; Recomended to enable
(require 'neat-completion)              ; A full-fledged completion configuration
(require 'neat-file-management)
(require 'neat-org)
(require 'neat-shells)
(require 'neat-ui)
;; (require 'neat-ui-extras)               ; TODO include transperency
;; (require 'neat-startup)                 ; TODO include a nice startup screen

;;; Writing
;; (require 'neat-tex)
;; (require 'neat-tex-templates)
(require 'neat-writing)                 ; Spell checking

;;; Keybindings
(require 'neat-evil)

;;; Programming
(require 'neat-python)
(require 'neat-lisp)
;; (require 'neat-java)                    ; TODO include java
;; (require 'neat-perl)                    ; TODO include perl
;; (require 'neat-c-sharp)                 ; TODO include c-sharp
;; (require 'neat-debugging)               ; TODO include dap debugging
(require 'neat-docker)

;;; Desktop mode
;; (require 'neat-desktop-xorg)
;; (require 'neat-desktop-wayland)

;;; Useful applications for desktop mode
;; (require 'neat-mu4e)
;; (require 'neat-pass)

;; Fonts
(add-hook 'emacs-startup-hook
          (lambda ()
            (custom-set-faces
             `(default ((t (:font "JetBrains Mono Light 11"))))
             `(fixed-pitch ((t (:inherit (default)))))
             `(fixed-pitch-serif ((t (:inherit (default)))))
             `(variable-pitch ((t (:font "Cantarell 11")))))))

;;; config.el ends here
