<div align="center">

# nix-config

![build](https://github.com/tbidne/nix-config/workflows/build/badge.svg?branch=main)
![nixfmt](https://github.com/tbidne/nix-config/workflows/nixfmt/badge.svg?branch=main)
</div>

This repository holds my `/etc/nixos/` config.

## Desktop

The wallpaper is set to whatever is in `$HOME/Pictures/Wallpaper/Current` via `feh` in `config.hs`. To test out new wallpapers, run `feh --bg-scale /path/to/wallpaper`.

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

The configuration is built with `nixos-rebuild switch --flake '.#nixos'`.

To update all inputs in `flake.lock`, run `nix flake update`.

To update a specific input, run `nix flake lock --update-input <input-name>`.

## Nix Shell
The line

```nix
{
  devShell."${system}" = import ./shell.nix { inherit pkgs; };
}
```

allows us to launch the nix shell with `nix develop`. This gives us the shell with the dependencies to use HLS with `config.hs`.

We can also launch a nix shell with `nix-shell`.

## Secrets

Building requires access to the hidden repository `git@github.com/tbidne/secrets`. Because `nixos-rebuild` is run with `sudo`, it doesn't have access to our normal user keys, thus this fails. We can get around this via:
- ssh key in `/root/.ssh`.
- add the following to `/root/.ssh/config`:

```sh
Host github.com
  HostName github.com
  User root
  IdentityFile /root/.ssh/id_ed25519
```

Then we can access the repository during building.
