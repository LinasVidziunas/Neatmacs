;;; neat-ui.el --- Neatmacs UI Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Module's features. tldr; Enabled with .. in ... Has the following:
;; - circadian
;; "Theme-switching for emacs based on daytime"
;; https://github.com/guidoschmidt/circadian.el
;;
;; By default uses daytime (08:00 -> 19:30) light and night time (19:30 -> 08:30) for light and dark themes, respectively.
;;
;; Recommended to configure for specific coordinates to better match real world daylight.
;; See https://github.com/guidoschmidt/circadian.el
;;
;; - doom-modeline
;; Replace standard modeline with Doom modeline
;;
;; For configuration, see https://github.com/seagle0128/doom-modeline
;;
;; - doom-themes

;;; Code:
(require 'use-package)

(defgroup neatmacs-ui '()
  "User Interface related configuration."
  :tag "Neat UI"
  :group 'neatmacs
  :prefix "neatmacs-ui-")

(defcustom neatmacs-ui-circadian nil
  "When non-nil, will use light and dark themes depending on the current time of day.

When set to non-nil, will install and load `X` package upon execution."
  :group 'neatmacs-ui
  :type 'boolean)

(defcustom neatmacs-ui-circadian-light-theme 'modus-operandi-deuteranopia
  "Light theme to use when `neatmacs-ui-circadian` is non-nil and ."
  :group 'neatmacs-ui
  :type 'symbol)

(defcustom neatmacs-ui-circadian-dark-theme 'modus-vivendi-deuteranopia
  "Dark theme for Neatmacs."
  :group 'neatmacs-ui
  :type 'symbol)

;; Source: https://emacsredux.com/blog/2025/02/03/clean-unloading-of-emacs-themes/
(defun neatmacs-ui--disable-all-active-themes ()
  "Disable all currently active themes."
  (interactive)
  (dolist (theme custom-enabled-themes)
    (disable-theme theme)))

;; Source: https://emacsredux.com/blog/2025/02/03/clean-unloading-of-emacs-themes/
(defun neatmacs-ui--load-theme (theme)
  "Disable all currently active themes and load THEME."
  (neatmacs-ui--disable-all-active-themes)
  (load-theme theme t))

(use-package emacs
  :ensure nil
  :custom
  (visible-bell t)
  :config
  (tooltip-mode -1)
  (set-fringe-mode 0))

(use-package modus-themes
  :ensure nil
  ;; :straight (:type built-in
  ;;                  :pre (emacs-version <= "28.0")) ; Built-in from 28.0
  :custom
  ;; Use bold and italic text in more code constructs
  (modus-themes-bold-constructs t)
  (modus-themes-italic-constructs t)

  (modus-themes-variable-pitch-ui t)
  (modus-themes-mixed-fonts t)

  ;; Org mode block style
  (modus-themes-org-blocks 'gray-background)

  ;; Toggle between color blind themes
  (modus-themes-to-toggle '(modus-operandi-deuteranopia modus-vivendi-deuteranopia))

  (modus-themes-common-palette-overrides
   '(
     ;; Disable modeline border
     (border-mode-line-active unspecified)
     (border-mode-line-inactive unspecified)

     ;;;(fringe unspecified)))
     )))


(require 'neat-modules)

(when (modulep! '+circadian)
  (use-package circadian
    :ensure t
    :config
    (setq circadian-themes '(("8:00" . adwaita)
                             ("19:30" . wombat)))
    (circadian-setup)))

(when (modulep! '+doom-themes)
  (use-package doom-themes
    ;; TODO defcustom or somehow define theme to load
    :hook (elpaca-after-init . (lambda () (neatmacs-ui--load-theme 'doom-acario-light)))))


(when (modulep! '+doom-modeline)
  (use-package doom-modeline
    :custom
    (doom-modeline-height 26)
    :init
    (doom-modeline-mode 1)))

(provide 'neat-ui)
;;; neat-ui.el ends here
