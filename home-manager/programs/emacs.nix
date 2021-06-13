{ ... }:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.company
      epkgs.evil
      epkgs.hasklig-mode
      epkgs.haskell-mode
      epkgs.ivy
      epkgs.lsp-haskell
      epkgs.lsp-ivy
      epkgs.lsp-latex
      epkgs.lsp-mode
      epkgs.lsp-treemacs
      epkgs.lsp-ui
      epkgs.nix-mode
      epkgs.nord-theme
      epkgs.projectile
      epkgs.treemacs
      epkgs.treemacs-evil
      epkgs.use-package
      epkgs.which-key
    ];
  };

  home.file = {
    ".emacs.d/init.el".text = ''
      ;; theme
      (use-package nord-theme
        :ensure t
        :init (load-theme 'nord t))

      ;; general
      (evil-mode 1)
      (global-hl-line-mode 1)
      (use-package treemacs)
      (use-package treemacs-evil)
      (use-package which-key
        :ensure t
        :init
        (setq which-key-separator " ")
        (setq which-key-prefix-prefix "+")
        :config
        (which-key-mode 1))

      (projectile-mode +1)
      (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

      ;; lsp
      (use-package lsp-mode
        :init
      ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
      (setq lsp-keymap-prefix "C-c l")
        :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
                (XXX-mode . lsp)
                ;; if you want which-key integration
                (lsp-mode . lsp-enable-which-key-integration))
        :commands lsp)(use-package lsp-mode
		        :ensure t)

      (use-package lsp-ui
                   :ensure t
                   :commands lsp-ui-mode)
      (use-package lsp-ivy
	           :ensure t
	           :commands lsp-ivy-workspace-symbol)
      (use-package lsp-treemacs :ensure t)

      ;; haskell
      (use-package haskell-mode :ensure t)
      (use-package lsp-haskell :ensure t)
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
        :hook (haskell-mode)
        :ensure t)

      (use-package nix-mode
        :mode "\\.nix\\'")
    '';
  };
}
