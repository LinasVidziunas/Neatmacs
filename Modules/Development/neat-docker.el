;;; neat-docker.el --- Neatmacs Docker Configuration --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'use-package)

(use-package docker
  :bind ("C-c d" . docker))

(use-package dockerfile-mode)

(provide 'neat-docker)
;;; neat-docker.el ends here
