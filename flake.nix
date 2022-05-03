{
  description = "My NixOS Config";

  inputs = {
    # nixpkgs
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
    , navi-src
    , nixpkgs
    , nur
    , pythia-src
    , ringbearer
    , self
    , shell-run-src
    }@inputs':
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      xmonad-ghc = pkgs.haskell.packages.ghc922.override (old: {
        overrides = pkgs.lib.composeExtensions (old.overrides or (_: _: { }))
          (final: prev: {
            dbus = prev.dbus_1_2_24;
          });
      });
      xmonad-extra = ps: with ps; [
        async
        dbus
        X11
        xmonad
        xmonad-contrib
        xmonad-utils
      ];
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            { nixpkgs.overlays = [ nur.overlay ]; }
            ({ pkgs, ... }:
              let
                inputs = inputs' // {
                  inherit
                    pkgs
                    system
                    xmonad-extra
                    xmonad-ghc;
                };
              in
              {
                imports = [
                  (import ./configuration.nix {
                    inherit inputs;
                  })

                  home-manager.nixosModules.home-manager
                  ({
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.tommy = (import ./home-manager/home.nix {
                      inherit inputs;
                    });
                  })
                ];
              }
            )
          ];
        };
      };
      devShell."${system}" =
        let hs-dev-tools = ps: [ ps.ghcid ps.haskell-language-server ];
        in
        pkgs.mkShell {
          buildInputs = [
            (xmonad-ghc.ghcWithPackages
              (ps: hs-dev-tools ps ++ xmonad-extra ps))
          ];
        };
    };
}
