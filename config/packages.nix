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

    # dev
    git
    gnumake
    jq
    lua
    neovim
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
    (inputs.src2pkg inputs.navi)
    (inputs.src2pkg inputs.path-size)
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

  programs.steam.enable = true;
  programs.gnupg.agent.enable = true;
}
