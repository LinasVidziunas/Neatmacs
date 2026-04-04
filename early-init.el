;;; early-init.el --- Early init -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 Linas Vidziunas
;;
;; Author: Linas Vidziunas <linasvidz@fedora>
;; Maintainer: Linas Vidziunas <linasvidz@fedora>
;; Created: April 03, 2026
;; Modified: April 03, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/linasvidz/early-init
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(load-theme 'modus-vivendi 't nil)

(setq package-enable-at-startup nil)

;; Store native compilation cache under `var/` to match `no-littering`.
;; https://github.com/emacscollective/no-littering?tab=readme-ov-file#native-compilation-cache
(when (and (fboundp 'startup-redirect-eln-cache)
           (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "var/eln-cache/" user-emacs-directory))))

(provide 'early-init)
;;; early-init.el ends here
