{
  description = "My NixOS Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/master";
    home-manager.url = "github:rycee/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #my-nixpkgs.url = "github:tbidne/nixpkgs/vscode-idris";
    my-nixpkgs.url = "github:tbidne/nixpkgs/aeschli.vscode-css-formatter";
  };

  outputs = { self, nixpkgs, home-manager, my-nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      my-pkgs = my-nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager ({
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tommy = {...}: {
                imports = [
                  ./home-manager/programs/chromium.nix
                  ./home-manager/programs/ghci.nix
                  ./home-manager/programs/git.nix
                  (import ./home-manager/programs/vscode.nix { inherit pkgs my-pkgs; })
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