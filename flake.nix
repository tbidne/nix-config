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
    impact.url = "github:tbidne/impact/main";

    # my repos
    navi-src.url = "github:tbidne/navi/main";
    pythia-src.url = "github:tbidne/pythia/main";
    shell-run-src.url = "github:tbidne/shell-run/main";
    time-conv-src.url = "github:tbidne/time-conv/main";
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
      # Downgraded due to core dump that periodically occurs. Note: I do not
      # know that this is the fault of ghc 9 or one of its newer deps.
      # The downgrade is merely a debugging attempt / mitigation tool.
      #
      # See https://github.com/xmonad/xmonad/issues/389.
      #
      #xmonad-ghc = pkgs.haskell.packages.ghc922.override (old: {
      #  overrides = pkgs.lib.composeExtensions (old.overrides or (_: _: { }))
      #    (final: prev: {
      #      dbus = prev.dbus_1_2_24;
      #    });
      #});
      xmonad-ghc = pkgs.haskell.packages.ghc8107;
      xmonad-extra = ps: with ps; [
        async
        dbus
        X11
        xmonad
        xmonad-contrib
        xmonad-utils
      ];
      src2pkg = src: src.defaultPackage."${system}";
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
