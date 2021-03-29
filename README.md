# nix-config

<p>
    <a href="https://github.com/tbidne/nix-config/workflows/build/badge.svg?branch=main" alt="build">
        <img src="https://img.shields.io/github/workflow/status/tbidne/nix-config/build/main?logo=NixOS&style=plastic&logoColor=7ebae4" height="20"/>
    </a>
</p>

This repository holds my `/etc/nixos/` config.

## Desktop

![Desktop](./Desktop_23-02-2021.png)

The wallpaper is set to whatever is in `$HOME/Pictures/Wallpaper/Current` via `feh` in `config.hs`.

The main desktop programs are:

- [xmonad](https://xmonad.org/)
- [Picom](https://github.com/yshui/picom)
- [Polybar](https://github.com/polybar/polybar)
  - [polybar-scripts/openweathermap-fullfeatured](https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/openweathermap-fullfeatured)
  - [OpenWeather](https://openweathermap.org/)
- [Rofi](https://github.com/davatorium/rofi)

## Betterlockscreen

To set `betterlockscreen` up, run `betterlockscreen -u path/to/wallpaper`. Then it will be usable via the config in `config.hs`.

## Flakes

Sometimes you have to first build with `nixos-rebuild switch --flake '#'`. I believe this is when we're on the "old nix" and have to do a "dry run" to let us use flakes before we can do the "real build". E.g., we must execute:

```nix
nix = {
  package = pkgs.nixFlakes;
  extraOptions = ''
    experimental-features = nix-command flakes
  '';
};
```

After that we can do the real build with `nixos-rebuild switch --flake ''`.

To update `flake.lock`, run `nix flake update`.

## Nix Shell
To launch a nix shell, for now you must specify the same revision it was built with. 

That is, since `flake.lock` currently has `nixpkgs` corresponding to

```nix
"nixpkgs": {
  "locked": {
    "lastModified": 1616779317,
    "narHash": "sha256-+mUTkYguFMNGb57JkwauDgjcq65RnOLUhDo4mhb8qAI=",
    "owner": "NixOS",
    "repo": "nixpkgs",
    "rev": "ad47284f8b01f587e24a4f14e0f93126d8ebecda",
    "type": "github"
  },
  "original": {
    "id": "nixpkgs",
    "ref": "nixos-unstable",
    "type": "indirect"
  }
}
```
We launch the shell with,

```shell
nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/ad47284f8b01f587e24a4f14e0f93126d8ebecda.tar.gz
```