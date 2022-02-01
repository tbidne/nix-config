;; Disable splash and toolbars
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; use-package
(require 'package)
(package-initialize 'noactivate)
(eval-when-compile
  (require 'use-package))

(use-package one-themes
  :init (load-theme 'one-dark t))

;; General
(evil-mode 1)
(global-hl-line-mode 1)
(setq make-backup-files nil)

;; Which-Key
(use-package which-key
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode 1))

;; Misc keymaps
(global-set-key (kbd "C-x w") 'whitespace-mode)
(global-set-key (kbd "C->") 'other-window)
(global-set-key (kbd "C-<") 'previous-window-any-frame)
(global-set-key (kbd "C-SPC") 'treemacs)

;; Treemacs
(use-package treemacs-all-the-icons)
(treemacs-load-theme "all-the-icons")
(setq lsp-treemacs-theme "all-the-icons")

(ivy-mode +1)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; LSP
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)
(use-package lsp-ui
  :commands lsp-ui-mode)
(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs)

;; Haskell
(use-package haskell-mode)
(use-package lsp-haskell)
;; Default is "haskell-language-server-wrapper", which does not seem to be set
;; by default when including hls via nix.
(setq lsp-haskell-server-path "haskell-language-server")
;; Hooks so haskell and literate haskell major modes trigger LSP setup
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)
(set-face-attribute 'default nil
  :height 100
  :family "Hasklig"
  :weight 'normal
  :width 'normal)
(add-to-list 'completion-ignored-extensions ".hi")
(use-package hasklig-mode
  :hook (haskell-mode))

;; Agda
;; We no longer have agda2 globally installed since that can lead to version
;; mismatches, so we locate it dynamically here instead.
(when
  (>
    (length (shell-command-to-string "command -v agda-mode"))
    0)
  (load-file (let ((coding-system-for-read 'utf-8))
  (shell-command-to-string "agda-mode locate"))))


;; LaTeX
(use-package lsp-latex)
(with-eval-after-load "tex-mode"
  (add-hook 'tex-mode-hook 'lsp)
  (add-hook 'latex-mode-hook 'lsp))

;; Nix
(use-package nix-mode
  :mode "\\.nix\\'")
