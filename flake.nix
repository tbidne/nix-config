{
  description = "My NixOS Config";

  inputs = {
    # nixpkgs
    my-nixpkgs.url = "github:tbidne/nixpkgs/vscode-exts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # utils
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";

    # fonts
    ringbearer.url = "github:tbidne/ringbearer/main";
    impact.url = "github:tbidne/impact/main";

    # my repos
    navi-src.url = "github:tbidne/navi/main";
    pythia-src.url = "github:tbidne/pythia/main";
    shell-run-src.url = "github:tbidne/shell-run/main";
  };

  outputs =
    { flake-utils
    , home-manager
    , impact
    , my-nixpkgs
    , navi-src
    , nixpkgs
    , nur
    , pythia-src
    , ringbearer
    , self
    , shell-run-src
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config = { allowUnfree = true; };

      };
      my-pkgs = import my-nixpkgs {
        system = system;
        config = { allowUnfree = true; };
      };
      pythia = pythia-src.defaultPackage.${system};
      navi = navi-src.defaultPackage.${system};
      shell-run = shell-run-src.defaultPackage.${system};

      # xmonad
      ghcCompiler = pkgs.haskell.packages."ghc922";
      xmonad-packages = ghcCompiler.override (old: {
        overrides = pkgs.lib.composeExtensions (old.overrides or (_: _: { }))
          (final: prev: {
            dbus = prev.dbus_1_2_24;
          });
      });
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            { nixpkgs.overlays = [ nur.overlay ]; }
            ({ pkgs, ... }:
              {
                imports = [
                  (import ./configuration.nix {
                    inherit
                      impact
                      navi
                      pkgs
                      pythia
                      ringbearer
                      shell-run
                      system
                      xmonad-packages;
                  })

                  home-manager.nixosModules.home-manager
                  ({
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.tommy = (import ./home-manager/home.nix {
                      inherit pkgs my-pkgs;
                    });
                  })
                ];
              }
            )
          ];
        };
      };
      devShell."${system}" = pkgs.mkShell {
        buildInputs = [
          (xmonad-packages.ghcWithPackages (ps: with ps; [
            async
            dbus
            haskell-language-server
            ghcid
            X11
            xmonad
            xmonad-contrib
            xmonad-utils
          ]))
        ];
      };
    };
}
