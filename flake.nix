{
  inputs = {
    nipkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";
  };

  outputs = {
    nixpkgs,
    mnw,
    self,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = func: nixpkgs.lib.genAttrs systems (system: func nixpkgs.legacyPackages.${system});
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (pkgs: rec {
      default = mnw.lib.wrap pkgs {
        neovim = pkgs.neovim-unwrapped;

        aliases = [
          "vi"
          "vim"
        ];

        initLua = ''
          require("soikr")
          LZN = require("lz.n")
          LZN.load("lazy")
        '';

        plugins = {
          start = with pkgs.vimPlugins; [
            kanagawa-nvim
            lz-n
            nvim-web-devicons
            plenary-nvim
          ];

          opt = with pkgs.vimPlugins; [
            aerial-nvim
            blink-cmp
            fidget-nvim
            friendly-snippets
            lazydev-nvim
            crates-nvim
            luasnip
            render-markdown-nvim
            nvim-lspconfig
            nvim-treesitter.withAllGrammars
            telescope-file-browser-nvim
            telescope-fzf-native-nvim
            telescope-nvim
            mini-nvim
            none-ls-nvim
          ];

          dev.config = {
            pure = ./.;
            impure = "~/Projects/flake-nvim";
          };
        };

        extraLuaPackages = ps: [ps.jsregexp];

        extraBinPath = with pkgs; [
          git # blink-cmp
          curl # blink-cmp, kulala
          jq # kulala
          libxml2 # kulala
          ripgrep # telescope
          fd # telescope

          # Languages
          ## Nix
          statix
          deadnix
          nil
          alejandra

          ## Lua
          lua-language-server
          stylua

          ## Rust
          rust-analyzer

          ## Python
          pyright
        ];
      };

      dev = default.devMode;
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages = [self.packages.${pkgs.system}.dev];
      };
    });
  };
}
