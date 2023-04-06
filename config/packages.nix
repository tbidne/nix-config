{ inputs }:

{
  environment.systemPackages = with inputs.pkgs; [
    # core
    brave
    chromium
    conky
    firefox
    gimp
    haruna
    peek

    # doc editing
    okular
    texlive.combined.scheme-full

    # dev
    entr
    git
    gnumake
    jq
    lua
    onefetch
    ruby
    sqitchPg
    sqlite
    vim
    vscodium

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

  programs.gnupg.agent.enable = true;
}
