{
  description = "My NixOS Config";

  inputs = {
    # nixpkgs + community
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
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
    safe-rm.url = "github:tbidne/safe-rm/main";
    navi.url = "github:tbidne/navi/main";
    pythia.url = "github:tbidne/pythia/main";
    shrun.url = "github:tbidne/shrun/main";
    time-conv.url = "github:tbidne/time-conv/main";
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
      # NOTE: The aforementioned xmonad bug was actually a ghc bug. There is
      # a workroung for older ghc versions in xmonad 0.17.1, but the bug itself
      # was fixed in ghc 9.2.4+. Thus we should be okay to simply upgrade ghc,
      # but if not we can upgrade xmonad manually instead.
      #
      # https://discourse.haskell.org/t/ghc-9-2-4-released/4851
      # https://xmonad.org/news/2022/09/03/xmonad-0-17-1.html
      xmonad-ghc = pkgs.haskell.packages.ghc924;

      xmonad-extra = ps: with ps; [
        async
        dbus
        X11
        xmonad
        xmonad-contrib
        xmonad-utils
      ];
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
                    catpuppucin
                    pkgs
                    src2pkg
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
