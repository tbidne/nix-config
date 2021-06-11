{
  description = "My NixOS Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/master";
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    my-nixpkgs.url = "github:tbidne/nixpkgs/aeschli.vscode-css-formatter";
    flake-utils.url = "github:numtide/flake-utils";
    ringbearer.url = "github:tbidne/ringbearer/main";
    ringbearer.inputs.nixpkgs.follows = "nixpkgs";
    ringbearer.inputs.flake-utils.follows = "flake-utils";
    shell-run-src.url= "github:tbidne/shell-run/main";
    shell-run-src.inputs.nixpkgs.follows = "nixpkgs";
    shell-run-src.inputs.flake-utils.follows = "flake-utils";

  };

  outputs = { self, nixpkgs, home-manager, my-nixpkgs, ringbearer, shell-run-src, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config = { allowUnfree = true; };
      };
      shell-run = shell-run-src.defaultPackage.${system};
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            (import ./configuration.nix { inherit pkgs system ringbearer shell-run; })
            home-manager.nixosModules.home-manager
            ({
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tommy = { ... }: {
                imports = [
                  ./home-manager/programs/chromium.nix
                  ./home-manager/programs/ghci.nix
                  ./home-manager/programs/git.nix
                  (import ./home-manager/programs/neovim.nix { inherit pkgs; })
                  (import ./home-manager/programs/vscode.nix { inherit pkgs; })
                  ./home-manager/programs/zsh.nix

                  ./home-manager/programs/xmonad/default.nix
                ];
              };
            })
          ];
        };
      };
      devShell."${system}" = import ./shell.nix { inherit pkgs; };
    };
}
