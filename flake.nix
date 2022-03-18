{
  description = "My NixOS Config";

  inputs = {
    # nixpkgs
    my-nixpkgs.url = "github:tbidne/nixpkgs/vscode-exts";

    # It appears that once again we have a bug. This time, suspend is not
    # going into low power mode, so the laptop runs out of battery much quicker
    # than it should.
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
    shell-run-src.url = "github:tbidne/shell-run/main";
    navi-src.url = "github:tbidne/navi/main";
  };

  outputs =
    { flake-utils
    , home-manager
    , impact
    , my-nixpkgs
    , navi-src
    , nixpkgs
    , nur
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
      shell-run = shell-run-src.defaultPackage.${system};
      navi = navi-src.defaultPackage.${system};
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
                    inherit pkgs system ringbearer impact shell-run navi;
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
      devShell."${system}" = import ./shell.nix { inherit pkgs; };
    };
}
