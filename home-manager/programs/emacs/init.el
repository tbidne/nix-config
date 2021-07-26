;; Disable splash and toolbars
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)

(load-theme 'dracula t)
(require 'dracula-theme)

;; General
(evil-mode 1)
(global-hl-line-mode 1)
(setq make-backup-files nil)

;; Which-Key
(setq which-key-separator " ")
(setq which-key-prefix-prefix "+")
(require 'which-key)
(which-key-mode 1)

;; Misc keymaps
(global-set-key (kbd "C-x w") 'whitespace-mode)
(global-set-key (kbd "C->") 'other-window)
(global-set-key (kbd "C-<") 'previous-window-any-frame)
(global-set-key (kbd "C-SPC") 'treemacs)

;; Treemacs
(require 'all-the-icons)
(require 'treemacs-all-the-icons)
(treemacs-load-theme "all-the-icons")
(setq lsp-treemacs-theme "all-the-icons")

(ivy-mode +1)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; LSP
(setq lsp-keymap-prefix "C-c l")
(autoload 'lsp-mode "lsp" nil t)
(require 'lsp-mode)

(autoload 'lsp-ui "lsp-ui-mode" nil t)
(require 'lsp-ui)

(autoload 'lsp-ivy "lsp-ivy-workspace-symbol" nil t)
(require 'lsp-ivy)

(require 'lsp-treemacs)

;; Haskell
(require 'haskell-mode)
(require 'lsp-haskell)
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)

(set-face-attribute 'default nil
		    :height 100
		    :family "Hasklig"
		    :weight 'normal
		    :width 'normal)
(add-to-list 'completion-ignored-extensions ".hi")
(require 'hasklig-mode)
(add-hook 'hasklig-mode "hasklig-mode" nil t)

;; LaTeX
(require 'lsp-latex)
(with-eval-after-load "tex-mode")
(add-hook 'tex-mode-hook 'lsp)
(add-hook 'latex-mode-hook 'lsp)

;; Nix
(require 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
