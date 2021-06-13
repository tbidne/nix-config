{ pkgs, shell-run, ... }:

{
  environment.systemPackages = with pkgs; [
    # core
    chromium
    conky
    firefox
    gimp
    google-chrome
    kitty
    pandoc
    texlive.combined.scheme-full
    thunderbird
    zoom-us

    # dev
    dbeaver
    git
    lua
    neovim
    nginx
    nodejs
    onefetch
    ruby
    sqitchPg
    sqlite
    vim
    vscodium

    # haskell
    cabal-install
    cabal2nix
    stack

    # my projects
    shell-run

    # utils
    fd
    gnupg
    gotop
    pv
    ripgrep
    tmux
    traceroute
    tree
    tty-clock
    unzip
    whois
    zip

    # misc
    nix-prefetch-git
  ];

  programs.steam.enable = true;
  programs.gnupg.agent.enable = true;
}
