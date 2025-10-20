## Flake Powered Neovim Config
Utilizes [mnw](https://github.com/Gerg-L/mnw) - Thank you for this!

Refactored configuration to look like [@Gerg-L's](https://github.com/Gerg-L) [nvim-flake](https://github.com/Gerg-L/nvim-flake). PLEASE check this out first.

I wouldn't recommend others to use my configuration, the code can be janky.

Still very much building onto this.

## Testing
```console
nix run github:Soikr/flakevim
```
```console
nix-shell -p '(import (builtins.fetchTarball "https://github.com/Soikr/flakevim/archive/master.tar.gz")).packages.${builtins.currentSystem}.default' --run nvim
```

## Installation
### Flakes
```nix
#flake.nix

{
  inputs = {
    nvim-flake = {
      url = "github:Soikr/flakevim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
...
```
### Legacy
```nix
let
  nvim-flake = import (builtins.fetchTarball {
  # Get the revision by choosing a version from https://github.com/Soikr/flakevim/commits/master
  url = "https://github.com/Soikr/flakevim/archive/<revision>.tar.gz";
  # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
  sha256 = "<hash>";
});
in
{
# add system wide
  environment.systemPackages = [
    nvim-flake.packages.${pkgs.stdenv.system}.neovim
  ];
# add per-user
  users.users."<name>".packages = [
    nvim-flake.packages.${pkgs.stdenv.system}.neovim
  ];
```
> [!TIP]
> Dont forget to make the inputs/flake accessible to your modules!
```nix
#anyModule.nix

# add system wide
  environment.systemPackages = [
    inputs.flakevim.packages.${pkgs.stdenv.system}.default
  ];
# add per-user
  users.users."<name>".packages = [
    inputs.flakevim.packages.${pkgs.stdenv.system}.default
  ];
```

## Updating
You can run `nix flake update` for flakes, and `npins --lock-file <start/opt>.json update --full` for npins.

Modify plugins with `npins --lock-file <start/opt>.json add/remove <github/source> <user> <repo>`

Access devshell via `nix develop`

## Credits
* [@Gerg-L's](https://github.com/Gerg-L) [nvim-flake](https://github.com/Gerg-L/nvim-flake)
* [@llakala's](https://github.com/llakala) [meowvim](https://github.com/llakala/meovim)
* [@frahz's](https://github.com/frahz) [nvim-flake](https://github.com/frahz/nvim-flake)
