{
  description = "My NixOS Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    my-nixpkgs.url = "github:tbidne/nixpkgs/vscode-exts";
    nur.url = "github:nix-community/NUR";
    ringbearer = {
      url = "github:tbidne/ringbearer/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    shell-run-src = {
      url = "github:tbidne/shell-run/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    static-assets-src = {
      url = "github:tbidne/static/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    # Need to have root key with repo access, i.e., /root/.ssh/...
    secrets-src.url = "git+ssh://git@github.com/tbidne/secrets?ref=main";
  };

  outputs = { self, nixpkgs, home-manager, nur, my-nixpkgs, ringbearer, shell-run-src, static-assets-src, secrets-src, ... }:
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
      static-assets = static-assets-src.defaultPackage.${system};
      secrets = secrets-src.outputs;
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
                  (import ./configuration.nix { inherit pkgs system ringbearer shell-run; })

                  home-manager.nixosModules.home-manager
                  ({
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.tommy = (import ./home-manager/home.nix { inherit pkgs my-pkgs static-assets secrets; });
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
