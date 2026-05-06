;;; neat-ai.el --- Neatmacs AI configuration -*- lexical-binding: t; -*-

;; Author: Linas Vidziunas <linasvidz@gmail.com>
;; URL: https://github.com/LinasVidziunas/Neatmacs
;; Version: 1.0.0
;; Package-Requires: ((emacs "27.1") (use-package "2.4") (gptel "0.9.0"))
;; Keywords: ai, gptel, openrouter, convenience

;;; Commentary:
;;
;; This module configures gptel to work seamlessly with OpenRouter.
;; It features a robust, multi-tier API key lookup system that checks:
;; 1. Environment variables (for quick session overrides)
;; 2. Auth-source/authinfo (for encrypted local storage)
;; 3. The system password store (pass)
;;
;; Additionally, it dynamically fetches the latest model list from
;; OpenRouter on startup with a graceful fallback if offline.

;;; Code:

(require 'use-package)
(require 'auth-source)
(require 'json)

(defun neat-ai--provider-api-key (host &optional env-var pass-path)
  "Generic lookup for API keys.
Priority:
1. ENV-VAR (if provided).
2. `auth-source' for HOST.
3. Password store (pass) at PASS-PATH or api/HOST."
  (let ((lookup-path (or pass-path (concat "api/" host))))
    (cond
     ;; 1. Environment Variable (Highest Priority)
     ((and env-var (getenv env-var))
      (getenv env-var))

     ;; 2. Auth-info (~/.authinfo or ~/.authinfo.gpg)
     ((let ((auth-result (auth-source-search :host host :user "apikey")))
        (when-let ((secret (plist-get (car auth-result) :secret)))
          (if (functionp secret) (funcall secret) secret))))

     ;; 3. Password Store (pass)
     ((executable-find "pass")
      (let ((pass-output (shell-command-to-string (concat "pass show " lookup-path))))
        (unless (string-empty-p pass-output)
          (car (split-string pass-output "\n" t))))))))

(defun neat-ai--openrouter-api-key ()
  "Get OpenRouter API key via generic provider helper."
  (neat-ai--provider-api-key "openrouter.ai" "OPENROUTER_API_KEY"))

(defun neat-ai--fetch-openrouter-models ()
  "Fetch available models from OpenRouter API with error handling."
  (let ((url "https://openrouter.ai/api/v1/models"))
    (condition-case err
        (with-current-buffer (url-retrieve-synchronously url)
          (goto-char url-http-end-of-headers)
          (let* ((json-object-type 'alist)
                 (data (json-read))
                 (models-list (cdr (assoc 'data data))))
            (mapcar (lambda (m)
                      (intern (cdr (assoc 'id m))))
                    models-list)))
      (error
       (message "neat-ai: Failed to fetch OpenRouter models (%s). Using fallbacks."
                (error-message-string err))
       '(anthropic/claude-opus-4.6
         anthropic/claude-sonnet-4.6
         minimax/minimax-m2.7
         moonshotai/kimi-k2.6
         z-ai/glm-5.1)))))

(use-package gptel
  :config
  (gptel-make-openai "OpenRouter"
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :stream t
    :key #'neat-ai--openrouter-api-key
    :models (neat-ai--fetch-openrouter-models)))

;; TODO
;; need transient to invoke ai

(provide 'neat-ai)

;;; neat-ai.el ends here
