{
  description = "My NixOS Config";

  inputs = {
    # nixpkgs + community
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";

    # plasma config
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    # other
    catpuppucin.url = "github:catppuccin/kitty";
    catpuppucin.flake = false;

    # my fonts
    ringbearer.url = "github:tbidne/ringbearer/main";
    ringbearer.inputs.nixpkgs.follows = "nixpkgs";
    impact.url = "github:tbidne/impact/main";
    impact.inputs.nixpkgs.follows = "nixpkgs";

    # my repos
    path-size.url = "github:tbidne/path-size/main";
    navi.url = "github:tbidne/navi/main";
    pythia.url = "github:tbidne/pythia/main";
    safe-rm.url = "github:tbidne/safe-rm/main";
    shrun.url = "github:tbidne/shrun/main";
    time-conv.url = "github:tbidne/time-conv/main";
  };

  outputs =
    { catpuppucin
    , home-manager
    , plasma-manager
    , nixpkgs
    , nur
    , self
    , ...
    }@inputs':
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      src2pkg = src:
        if src ? packages."${system}".default
        then src.packages."${system}".default
        else src.defaultPackage."${system}";
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
                    src2pkg
                    system;
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

                    home-manager.sharedModules = [
                      plasma-manager.homeManagerModules.plasma-manager
                    ];
                  })
                ];
              }
            )
          ];
        };
      };
    };
}
