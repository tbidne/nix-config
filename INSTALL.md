# ISO

Download the latest [ISO](https://nixos.org/download.html) and burn to a disk/usb-drive or leave as-is if this is for `VirtualBox`.

# Native

These instructions are for installation on real hardware, not a virtual machine.

## Partitioning

These instructions assume the disk to partition is named `$disk`, thus the primary and boot partitions will be `$disk1` and `$disk2`, respectively (order of the `mkpart` commands is why this order matters). Adjust to the actual disk/partition names (e.g. `/dev/sda`) as necessary.

Start `sudo parted $disk` and run the following commands:

```sh
mklabel gpt
mkpart primary 512MiB 100%
mkpart ESP fat32 1MiB 512MiB
set 2 esp on
name 1 nixos
name 2 boot

quit
```

## Full Disk Encryption

To enable full disk encryption, run:

```sh
sudo cryptsetup -vy luksFormat $disk1
sudo cryptsetup luksOpen $disk1 cryptroot
```

## Formatting

Next, format each partition. With the encryption from the previous step, the command would be:

```sh
sudo mkfs.ext4 -L nixos /dev/mapper/cryptroot
```

If that step was skipped then it would just be:

```sh
sudo mkfs.ext4 -L nixos $disk1
```

In either case, formatting the boot partition is:

```sh
sudo mkfs.fat -F 32 -n boot $disk2
```

## Configure

First, we need to mount the disk.

```sh
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

Then run `sudo nixos-generate-config --root /mnt` and `cd /mnt/etc/nixos`.

From here, edit `configuration.nix` as necessary. This includes:

```nix
{
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # get interfaces from ifconfig
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  users.users.tommy = {
    name = "tommy";
    description = "Tommy Bidne";
    group = "users";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
    createHome = true;
    home = "/home/tommy";
  };

  environment.systemPackages = with pkgs; [
    firefox
    git
    vim
  ];

  # Using swapfile since it's easier with full disk encryption.
  # Size is 2 x RAM.
  swapDevices = [
    {
      device = "/swapfile";
      size = 1024 * 16 * 2;
    }
  ];
}
```

After the edits are made, run `sudo nixos-install`.

## User password

Reboot and login as root. Run `passwd <user>` to set the user password. Log out as root and log back in with the new user/pass.

## Flakes

To enable flakes, edit `configuration.nix`:

```nix
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
```

and rebuild with `sudo nixos-rebuild switch`.

## Clone git repository

First, back up `configuration.nix` and `hardware-configuration.nix` then clean out the `/etc/nixos` directory.

Clone the repo: `git clone git@github.com:tbidne/nix-config.git .`. This requires an ssh key set up with github. Additionally, because this repo involves the private repo `tbidne/secrets`, the [README#Secrets](README.md#secrets) instructions are a prerequisite.

Restore the original `hardware-configuration.nix` (thus overwriting the one from the repo), and change any other needed values. Typical changes include:

* `configuration.nix`
  * Ensure `system.stateVersion` matches what the system was built with.
* `config/packages.nix`
  * Add/remove desired programs.
* `config/user.nix`
  * Add `"vboxuser"` to `extraGroups`.
* `flake.lock`
  * If the same version of `nixpkgs` is desired, edit its hash (get current version with `nixos-version --hash`).
* `system/network.nix`
  * Match interfaces to whatever was in the original `configuration.nix`.
* `system/swap.nix`
  * Ensure swap settings from original `configuration.nix` match those in `system/swap.nix`

Finish with `sudo nixos-rebuild switch --flake '.#nixos'`.

# VirtualBox

`VirtualBox` should have the following settings:

* System
  * Motherboard
    * Enable EFI
  * Processor
    * Processors: max available
* Display
  * Screen
    * Video Memory: max available
    * Graphics Controller: VMSVGA
    * 3D acceleration: enabled
* Storage
  * NixOS ISO loaded into optical drive

Installation on a `VirtualBox` image is largely the same as on real hardware with a few complications. To wit:

* The following line should be added to `configuration.nix` in the first build.

    ```nix
    {
      virtualisation.virtualbox.guest.enable = true;
    }
    ```

    In the git clone step, this will be added to `system/vbox.nix`, and the host options should be removed.

* The HiDPI settings are not needed on `VirtualBox`, so these can be removed from `config/xmonad.nix` and `home-manager/programs/xmonad/xmonad.nix`.

* `kitty` does not play nicely with `VirtualBox`, so it is advisable to switch in `Xmonad`, i.e, modify `home-manager/programs/xmonad/config.hs`:

    ```haskell
    myTerminal :: String
    -- myTerminal = "kitty"
    myTerminal = "xterm"
    ```
