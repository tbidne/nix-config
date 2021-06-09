{ pkgs }:
{
  programs.neovim = {
    enable = true;

    extraConfig = ''
      colorscheme nord
      let g:airline_theme='deus'
    '';

    plugins = with pkgs.vimPlugins; [
      nord-vim
      coc-nvim
      ctrlp
      fugitive
      haskell-vim
      nerdtree
      vim-airline
      vim-airline-themes
      vim-hoogle
      vim-gitgutter
      vim-lsp
      vim-nix
    ];
  };

  home.file = {
    ".config/nvim/coc-settings.json".text = ''
      {
        "languageserver": {
          "haskell": {
            "command": "haskell-language-server-wrapper",
            "args": [
              "--lsp"
            ],
            "filetypes": [
              "hs",
              "lhs",
              "haskell"
            ]
          }
        }
      }
    '';
  };
}
