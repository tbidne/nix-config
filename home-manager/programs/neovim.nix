{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    extraConfig = ''
      colorscheme nord
      set termguicolors
      let g:airline_theme='base16_nord'

      let NERDTreeShowHidden=1

      nmap <C-p> :FZF<CR>
      nmap <C-t> :NERDTreeToggle<CR>
      nmap <Tab> <C-w>w
      nmap <C-h> :call CocAction('doHover')<CR>
      nmap <C-b> :ToggleBufExplorer<CR>
    '';

    plugins = with pkgs.vimPlugins; [
      bufexplorer
      coc-nvim
      editorconfig-vim
      fugitive
      fzf-vim
      haskell-vim
      nerdtree
      nord-vim
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
