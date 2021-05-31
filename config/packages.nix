{ pkgs, ... }:

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
  

    # dev
    dbeaver
    git
    lua
    nginx
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

    # utils
    gnupg
    gotop
    pv
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
