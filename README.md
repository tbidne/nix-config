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
The line

```nix
devShell."${system}" = import ./shell.nix { inherit pkgs; };
```

allows us to launch the nix shell with `nix develop`. This gives us the shell with the dependencies to use HLS with `config.hs`.

We can also launch a nix shell with `nix-shell`.