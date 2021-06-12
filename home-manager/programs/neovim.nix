{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    extraConfig = ''
      colorscheme nord
      let g:airline_theme='deus'
      let NERDTreeShowHidden=1
      let g:ctrlp_show_hidden=1
    '';

    plugins = with pkgs.vimPlugins; [
      nord-vim
      coc-nvim
      ctrlp
      fugitive
      fzf-vim
      haskell-vim
      nerdtree
      vim-airline
      vim-airline-themes
      vim-markdown-composer
      vim-gitgutter
      vim-hoogle
      vim-lsp
      vim-nix
    ];
  };

  home.file = {
    ".config/nvim/coc-settings.json".text = ''
      {
        "languageserver": {
          "haskell": {
            "command": "haskell-language-server",
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
