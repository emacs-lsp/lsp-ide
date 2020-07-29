(setq
 package-user-dir "/tmp/new"
 inhibit-splash-screen t
 package-selected-packages
 '(lsp-mode
   ;; optional, needed for snippets
   yasnippet
   ;; usability (optional)
   lsp-treemacs company-posframe helm-lsp  ;; or lsp-ivy
   ;; external lsp clients (optional)
   lsp-dart lsp-java lsp-python-ms lsp-metals
   ;; helper packages
   projectile hydra flycheck company avy which-key helm-xref
   ;; major modes not in emacs core (optional if you use these languages)
   php-mode rust-mode haskell-mode scala-mode
   ;; beautifiers (optional)
   diminish helm-icons ;; lsp-ui
   ;; optional debugger
   dap-mode quelpa gruvbox-theme))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(setq company-tooltip-margin 2)

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)

  (package-install 'quelpa)
  (mapc #'quelpa '((company :fetcher github
                            :repo "yyoncho/company-mode"
                            :branch "icons"
                            :files ("*.el" "icons"))
                   (lsp-mode :fetcher github
                             :repo "yyoncho/lsp-mode"
                             :branch "icons-company"
                             :files ("*.el"))))

  (mapc #'package-install package-selected-packages))

(load-theme 'gruvbox t)

;; helm configuration
(helm-icons-enable)
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] 'helm-find-files)
(define-key global-map [remap execute-extended-command] 'helm-M-x)
(define-key global-map [remap switch-to-buffer] 'helm-mini)

(with-eval-after-load 'lsp-treemacs
  (treemacs-resize-icons 15))

(which-key-mode)
(add-hook 'prog-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      ;; more compact
      treemacs-space-between-root-nodes nil
      ;; less noise
      lsp-completion-show-detail nil
      helm-buffer-details-flag nil
      lsp-completion-show-kind nil
      flycheck-indication-mode nil
      company-tooltip-minimum-width 60
      company-tooltip-maximum-width 60
      company-posframe-show-indicator nil
      company-frontends '(company-pseudo-tooltip-frontend)
      lsp-completion-show-detail nil
      lsp-completion-show-kind nil
      ;; resposibility
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1
      ;; more context
      lsp-headerline-breadcrumb-enable t)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (add-hook 'lsp-managed-mode-hook #'lsp-diagnostics-modeline-mode)
  (add-hook 'lsp-managed-mode-hook #'company-posframe-mode)
  (yas-global-mode))
