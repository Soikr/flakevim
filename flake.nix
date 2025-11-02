{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    neovim-nightly = {
      type = "github";
      owner = "nix-community";
      repo = "neovim-nightly-overlay";
    };
    flake-compat = {
      type = "github";
      owner = "edolstra";
      repo = "flake-compat";
      flake = false;
    };
    mnw = {
      type = "github";
      owner = "gerg-l";
      repo = "mnw";
    };
  };

  outputs = {
    self,
    nixpkgs,
    mnw,
    ...
  } @ inputs: let
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    eachSystem = nixpkgs.lib.genAttrs systems;
  in {
    #
    # Linter and formatter, run with "nix fmt"
    # You can use alejandra or nixpkgs-fmt instead of nixfmt if you wish
    #
    formatter = eachSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.writeShellApplication {
          name = "format";
          runtimeInputs = builtins.attrValues {
            inherit
              (pkgs)
              alejandra
              deadnix
              statix
              fd
              stylua
              ;
          };
          text = ''
            fd "$@" -t f -e nix -x statix fix -- '{}'
            fd "$@" -t f -e nix -X deadnix -e -- '{}' \; -X alejabdra --quiet '{}'
            fd "$@" -t f -e lua -X stylua --indent-type Spaces --indent-width 2 '{}'
          '';
        }
    );

    devShells = eachSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShellNoCC {
          packages = [
            self.packages.${system}.default.devMode
            self.formatter.${system}
            pkgs.npins
          ];
        };
      }
    );

    packages = eachSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = self.packages.${system}.neovim;

        blink-cmp = pkgs.callPackage ./packages/blink-cmp/package.nix { };

        neovim = mnw.lib.wrap {inherit pkgs inputs;} ./config.nix;
      }
    );
  };
}
