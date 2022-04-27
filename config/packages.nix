{ inputs }:

let
  pythia = inputs.pythia-src.defaultPackage.${inputs.system};
  navi = inputs.navi-src.defaultPackage.${inputs.system};
  shell-run = inputs.shell-run-src.defaultPackage.${inputs.system};
in
{
  environment.systemPackages = with inputs.pkgs; [
    # core
    brave
    chromium
    conky
    firefox
    gimp
    google-chrome
    haruna
    thunderbird

    # doc editing
    libreoffice
    okular
    pandoc
    texlab # for lsp + latex
    texlive.combined.scheme-full

    # social
    discord
    element-desktop
    matterhorn
    mattermost-desktop
    slack
    zoom-us

    # dev
    emacs
    dbeaver
    git
    insomnia
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

    # my projects
    navi
    pythia
    shell-run

    # network utils
    traceroute
    whois

    # search utils
    fd
    fzf
    ripgrep
    silver-searcher

    # terminals
    kitty
    tmate
    tmux

    # misc utils
    acpi
    dig
    gnupg
    gotop
    libnotify
    lm_sensors
    lsof
    nix-prefetch-git
    openssl
    powerline
    pv
    tree
    unzip
    xclip
    zip
  ];

  programs.steam.enable = true;
  programs.gnupg.agent.enable = true;
}
