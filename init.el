;;; init.el --- Minimal lsp-mode focused startup         -*- lexical-binding: t; -*-
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(setq package-selected-packages '(posframe flycheck lsp-mode hydra company which-key lsp-java dap-mode helm-lsp lsp-treemacs projectile yasnippet))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (package-install-selected-packages))

(helm-mode)
(which-key-mode)
(add-hook 'prog-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil)

(with-eval-after-load 'lsp-java
  (require 'dap-java))

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook 'lsp-enable-which-key-integration)
  (dap-auto-configure-mode)
  (yas-global-mode))
