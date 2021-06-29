{ ... }:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.all-the-icons
      epkgs.company
      epkgs.dracula-theme
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
      epkgs.projectile
      epkgs.treemacs
      epkgs.treemacs-all-the-icons
      epkgs.treemacs-evil
      epkgs.use-package
      epkgs.which-key
    ];
  };

  home.file = {
    ".emacs.d/init.el".text = ''
      ;; disable splash and toolbars
      (setq inhibit-startup-screen t) 
      (menu-bar-mode -1)
      (tool-bar-mode -1)

      ;; theme
      (use-package dracula-theme
        :ensure t
        :init (load-theme 'dracula t))

      ;; general
      (evil-mode 1)
      (global-hl-line-mode 1)
      (setq make-backup-files nil)

      (use-package which-key
        :ensure t
        :init
        (setq which-key-separator " ")
        (setq which-key-prefix-prefix "+")
        :config
        (which-key-mode 1))

      ;; Misc keymaps
      (global-set-key (kbd "C-x w") 'whitespace-mode)
      (global-set-key (kbd "<tab>") 'other-window)
      (global-set-key (kbd "C-SPC") 'treemacs)

      (use-package treemacs-all-the-icons)
      (treemacs-load-theme "all-the-icons")
      (setq lsp-treemacs-theme "all-the-icons")

      (ivy-mode +1)
      (projectile-mode +1)
      (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

      ;; lsp
      (use-package lsp-mode
        :init
        ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
        (setq lsp-keymap-prefix "C-c l")
        :hook ((lsp-mode . lsp-enable-which-key-integration))
        :commands lsp)

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
