(require 'neat-sys-deps)

(use-package rg
  :sys-deps
  ;; Defining the dependency "ripgrep"
  ("ripgrep" :version ">=13.0"
              :description "Extremely fast line-oriented search tool"
              :managers ((apt . "ripgrep")
                         (brew . "ripgrep")
                         (pacman . "ripgrep")
                         (dnf . "ripgrep"))))
