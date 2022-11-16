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
    (inputs.src2pkg inputs.fs-utils)
    (inputs.src2pkg inputs.navi)
    (inputs.src2pkg inputs.pythia)
    (inputs.src2pkg inputs.safe-rm)
    (inputs.src2pkg inputs.shrun)
    (inputs.src2pkg inputs.time-conv)

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

    # reading ntfs drives
    # e.g. sudo mount -t ntfs /dev/sda2 ~/Mnt
    ntfs3g
  ];

  # See https://docs.hercules-ci.com/arion/#_installation
  virtualisation.docker.enable = false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.defaultNetwork.dnsname.enable = true;

  programs.steam.enable = true;
  programs.gnupg.agent.enable = true;
}
