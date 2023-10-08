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

    # For emailing books to kindle, set up sharing by email with email server:
    #
    # hostname: smtp.gmail.com
    # username: <email>
    # password: <app password>
    # encryption: tls
    calibre

    # Hotspot. Not strictly necessary for calibre, but makes it easy to
    # allow kindle to connect to this laptop's wifi.
    linux-wifi-hotspot

    # social
    slack
    zoom-us

    # doc editing
    okular
    pandoc
    texlive.combined.scheme-full

    # dev
    awscli2
    aws-vault
    dbeaver
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
