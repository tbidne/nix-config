let
  init-script = builtins.readFile ./init.el;
in
{
  # For the record, these get loaded into
  # /nix/store/.../emacs-package-deps/share/emacs/site-lisp/elpa
  # and possibly a few other places.
  #
  # To get the directory(s), run <C-h v> package-direcory-list
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.ag
      epkgs.all-the-icons
      epkgs.company
      epkgs.dracula-theme
      epkgs.evil
      epkgs.hasklig-mode
      epkgs.haskell-mode
      epkgs.ivy
      epkgs.lispy
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
      epkgs.which-key
    ];
  };

  home.file = {
    ".emacs.d/init.el".text = ''
      ${init-script}
    '';
  };
}
