{
  description = "My NixOS Config";

  inputs = {
    # nixpkgs + community
    # https://github.com/NixOS/nix/issues/9052
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";

    # other
    catpuppucin.url = "github:catppuccin/kitty";
    catpuppucin.flake = false;

    # my fonts
    ringbearer.url = "github:tbidne/ringbearer/main";
    ringbearer.inputs.nixpkgs.follows = "nixpkgs";
    impact.url = "github:tbidne/impact/main";
    impact.inputs.nixpkgs.follows = "nixpkgs";

    # my repos
    charon.url = "github:tbidne/charon";
    path-size.url = "github:tbidne/path-size";
    pythia.url = "github:tbidne/pythia";
    navi.url = "github:tbidne/navi";
    shrun.url = "github:tbidne/shrun/main";
    time-conv.url = "github:tbidne/time-conv";
  };

  outputs =
    { catpuppucin
    , home-manager
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
                  })
                ];
              }
            )
          ];
        };
      };
    };
}
