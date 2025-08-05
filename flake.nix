{
  description = "My NixOS Config";

  inputs = {
    # nixpkgs + community
    # https://github.com/NixOS/nix/issues/9052
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # other
    catpuppucin.url = "github:catppuccin/kitty";
    catpuppucin.flake = false;

    # my fonts
    ringbearer.url = "github:tbidne/ringbearer/main";
    ringbearer.inputs.nixpkgs.follows = "nixpkgs";
    impact.url = "github:tbidne/impact/main";
    impact.inputs.nixpkgs.follows = "nixpkgs";

    # my repos
    cabal-monitor.url = "github:tbidne/cabal-monitor";
    charon.url = "github:tbidne/charon";
    kairos.url = "github:tbidne/kairos";
    pacer.url = "github:tbidne/pacer/main";
    path-size.url = "github:tbidne/path-size";
    pythia.url = "github:tbidne/pythia";
    navi.url = "github:tbidne/navi";
    shrun.url = "github:tbidne/shrun";
    todo.url = "github:tbidne/todo";
  };

  outputs =
    {
      catpuppucin,
      home-manager,
      nixpkgs,
      nur,
      plasma-manager,
      self,
      ...
    }@inputs':
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      src2pkg =
        src:
        if src ? packages."${system}".default then
          src.packages."${system}".default
        else
          src.defaultPackage."${system}";
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            { nixpkgs.overlays = [ nur.overlays.default ]; }
            (
              { pkgs, ... }:
              let
                inputs = inputs' // {
                  inherit pkgs src2pkg system;
                };
              in
              {
                imports = [
                  (import ./configuration.nix { inherit inputs; })

                  home-manager.nixosModules.home-manager
                  ({
                    # backupFileExtension because switch started failing and
                    # logs suggested it.
                    home-manager.backupFileExtension = ".bak";
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.tommy = (import ./home-manager/home.nix { inherit inputs; });

                    home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
                  })
                ];
              }
            )
          ];
        };
      };
    };
}
