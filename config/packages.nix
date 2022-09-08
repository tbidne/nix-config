{ inputs }:

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
    peek
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
    arion
    cachix
    dbeaver
    docker
    docker-client
    git
    gnumake
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

    ## doom emacs
    coreutils
    clang
    python3 # treemacs
    emacs

    # my projects
    (inputs.src2pkg inputs.navi-src)
    (inputs.src2pkg inputs.pythia-src)
    (inputs.src2pkg inputs.shrun-src)
    (inputs.src2pkg inputs.time-conv-src)

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
    pv
    tree
    unzip
    xclip
    zip
  ];

  # See https://docs.hercules-ci.com/arion/#_installation
  virtualisation.docker.enable = false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.defaultNetwork.dnsname.enable = true;

  programs.steam.enable = true;
  programs.gnupg.agent.enable = true;
}
