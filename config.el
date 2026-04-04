;;; config.el --- User configuration for Neatmacs -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Author: Linas Vidziunas <linasvidz@gmail.com>
;; Maintainer: Linas Vidziunas <linasvidz@gmail.com>
;;
;; Loading Neatmacs modules,
;; and user-written code.
;;
;;; Code:

(defun neatmacs-require (module)
  "Require MODULE, and time the loading."
  (let ((start-time (current-time)))
    (require module)
    (message "Loaded %s in %.3fs" module (float-time (time-since start-time)))))


(cond ((eq system-type 'darwin)
       (neatmacs-require 'neat-macos)))

;;; ============================== Modules ==============================

;;; Base
(neatmacs-require 'neat-defaults)                ; Recommended to enable
(neatmacs-require 'neat-ui)                      ; UI improvements
(neatmacs-require 'neat-completion)              ; A full-fledged completion configuration
;; (neatmacs-require 'neat-file-management)         ; Improvements to dired and treemacs
;; (neatmacs-require 'neat-org)                     ; Default Org configuration
;; (neatmacs-require 'neat-org-extras)              ; Aesthetically pleasing Org configuration
;; (neatmacs-require 'neat-shells)                  ; Terminal configurations
;; (neatmacs-require 'neat-ui-extras)               ; UI extra goodies
;; (neatmacs-require 'neat-authentication)          ; Store encrypted passwords
;; (neatmacs-require 'neat-tab-bar-workspaces)      ; Tab bar workspaces
;; (neatmacs-require 'neat-history)                 ; Additional history settings. Saves minibuffer and last visited file positions.


;;; Writing
;; (neatmacs-require 'neat-tex)                     ; Probably unnecessary
;; (neatmacs-require 'neat-writing)                 ; Spell checking
;; (neatmacs-require 'neat-bibliography)            ; Bibliography


;;; Keybindings
(neatmacs-require 'neat-evil)                    ; VI style keybindings


;;; Development
(neatmacs-require 'neat-development)             ; Neatmacs development base
;; (neatmacs-require 'neat-python)                  ;
;; (neatmacs-require 'neat-lisp)                    ;
;; (neatmacs-require 'neat-docker)                  ; Depends on lsp mode
;; (neatmacs-require 'neat-java)                    ; Java & Kotlin programming improvements
;; (neatmacs-require 'neat-go)                      ; Go programming improvements
;; (neatmacs-require 'neat-web)
;; (require 'neat-perl)                    ; TODO include perl
;; (require 'neat-c-sharp)                 ; TODO include c-sharp
;; (require 'neat-debugging)               ; TODO include dap debugging


;;; Artificial intelligence
;; (neatmacs-require 'neat-ai)


;;; Desktop mode
;; (neatmacs-require 'neat-desktop)
;; (require 'neat-desktop-xorg)
;; (require 'neat-desktop-wayland)

;;; Useful applications for desktop mode
;; (require 'neat-mu4e)
;; (require 'neat-pass)

;; Fonts
;; (add-hook 'emacs-startup-hook
;;           (lambda ()
;;             (custom-set-faces
;;              `(default ((t (:font "JetBrains Mono Light 11"))))
;;              `(fixed-pitch ((t (:inherit (default)))))
;;              `(fixed-pitch-serif ((t (:inherit (default)))))
;;              `(variable-pitch ((t (:font "Cantarell 11")))))))

;;; config.el ends here
