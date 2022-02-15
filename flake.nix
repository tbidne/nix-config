{
  description = "My NixOS Config";

  inputs = {
    # nixpkgs
    # Downgrade nixpkgs and home-manager until NixOS/nixpkgs/pull/159255 is
    # merged. See https://nixpk.gs/pr-tracker.html?pr=159255.
    nixpkgs.url = "github:nixos/nixpkgs?rev=689b76bcf36055afdeb2e9852f5ecdd2bf483f87";
    my-nixpkgs.url = "github:tbidne/nixpkgs/vscode-exts";

    # utils
    home-manager.url = "github:nix-community/home-manager?rev=acf824c9ed70f623b424c2ca41d0f6821014c67c";
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
