{
  inputs,
  lib,
  pkgs,
  ...
}: {
  inherit (inputs.neovim-nightly.packages.${pkgs.stdenv.system}) neovim;

  appName = "sata";

  extraLuaPackages = p: [p.jsregexp];

  providers = {
    ruby.enable = true;
    python3.enable = true;
    nodeJs.enable = true;
    perl.enable = true;
  };

  # Source lua config
  initLua = ''
    require("soikr")
    LZN = require("lz.n")
    LZN.load("lazy")
  '';

  desktopEntry = false;
  plugins = {
    dev.config = {
      pure = let
        fs = lib.fileset;
      in
        fs.toSource {
          root = ./.;
          fileset = fs.unions [./lua];
        };
      impure = "~/Projects/nvim-flake/soikr";
    };

    start = inputs.mnw.lib.npinsToPlugins pkgs ./start.json;

    opt =
      [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
        inputs.self.packages.${pkgs.stdenv.system}.blink-cmp
      ]
      ++ inputs.mnw.lib.npinsToPlugins pkgs ./opt.json;
  };

  extraBinPath = builtins.attrValues {
    #
    # Runtime dependencies
    #
    inherit
      (pkgs)
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
      ;
  };
}
