;;;; neat-org.el --- Neatmacs Org Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration for the Lisp family of languages, including Common
;; Lisp, Clojure, Scheme, and Racket

;; Requirements:
;;; org-download:
;;;  `pngpaste` - `brew install pngpaste`

;;; Code:

(require 'use-package)

(use-package org
  :straight (:type built-in)
  :hook (org-mode . visual-line-mode)
  :config
  (require 'org-tempo)

  ;; Structure templates
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))

  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))

  ;; Babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (python . t)
     (latex . t))))

(use-package org-modern
  :after org
  :custom
  (org-modern-table nil)
  :config
  (global-org-modern-mode))

;; Org babel asynchronous execution
(use-package ob-async
  :after org ob
  :custom
  ;; Disable asynchronous for the following languages
  (ob-async-no-async-languages-alist '("ipython")))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/org-files/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package toc-org)

(use-package org-download)

(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
               '("simple"
                 "\\documentclass{article}
    [NO-DEFAULT-PACKAGES]
    [PACKAGES]
    [EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))


(require 'ox-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
             '("school_assignment"
               "\\documentclass{article}
      \\usepackage{listings}
      \\usepackage{color}
      \\usepackage{xcolor}
      \\usepackage{fancyvrb}
      \\usepackage[margin=0.5in]{geometry}

      \\DeclareFixedFont{\\ttb}{T1}{txtt}{bx}{n}{12} % for bold
      \\DeclareFixedFont{\\ttm}{T1}{txtt}{m}{n}{12}  % for normal

      \\definecolor{deepblue}{rgb}{0,0,0.5}
      \\definecolor{linasyellow}{rgb}{1,1,0.7}
      \\definecolor{deepred}{rgb}{0.6,0,0}
      \\definecolor{deepgreen}{rgb}{0,0.5,0}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
(add-to-list 'org-latex-classes
             '("exam"
               "\\documentclass{article}
      \\usepackage{listings}
      \\usepackage{color}
      \\usepackage{xcolor}
      \\usepackage{fancyvrb}
      \\usepackage{mdframed}
      \\usepackage[margin=2cm]{geometry}

      \\DeclareFixedFont{\\ttb}{T1}{txtt}{bx}{n}{12} % for bold
      \\DeclareFixedFont{\\ttm}{T1}{txtt}{m}{n}{12}  % for normal

      \\definecolor{deepblue}{rgb}{0,0,0.5}
      \\definecolor{linasyellow}{rgb}{1,1,0.7}
      \\definecolor{deepred}{rgb}{0.6,0,0}
      \\definecolor{deepgreen}{rgb}{0,0.5,0}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Use listing for source code blocks
(setq org-latex-listings t)

(setq org-latex-listings-options
      '(("basicstyle" "\\footnotesize\\ttfamily")
        ("breaklines" "true")
        ("fancyvrb" "true")
        ("showstringspaces" "false")
        ("frame" "tb")
        ("numbers" "none")
        ("stepnumber" "1")
        ("showlines" "true")
        ("aboveskip" "\\baselineskip")
        ("backgroundcolor" "\\color{gray!10!white}")
        ("commentstyle" "\\itshape\\color{purple!40!black}")))


(provide 'neat-org)
;;; neat-org.el ends here
