{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    extraConfig = ''
      colorscheme nord
      "set termguicolors
      let g:airline_theme='base16_nord'

      let NERDTreeShowHidden=1
      
      "set whitespace with :set list
      :set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·

      "use system keyboard
      set clipboard+=unnamedplus

      nmap <C-p> :FZF<CR>
      nmap <C-t> :NERDTreeToggle<CR>
      nmap <Tab> <C-w>w
      nmap <C-b> :ToggleBufExplorer<CR>
      nmap <C-s> :set list!<CR>

      "CoC Actions
      nmap <C-f> :call CocAction('format')<CR>
      nmap <C-h> :call CocAction('doHover')<CR>
      nmap <C-j> :call CocAction('jumpDefinition')<CR>
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
      vim-sleuth
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
            "rootPatterns": [
              "*cabal",
              "cabal.project",
              "stack.yaml",
              "package.yaml",
              "hie.yaml",
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
