;;; neat-docker.el --- Neatmacs Docker Configuration --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'use-package)

(use-package docker
  :bind ("C-c d" . docker))

(use-package dockerfile-mode
  :mode "Dockerfile\\'")

;; TODO: Seems like a scam
(use-package docker-compose-mode
  :mode "docker-compose.yml")

  (provide 'neat-docker)
;;; neat-docker.el ends here
