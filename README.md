## Flake Powered Neovim Config
<img width="2540" height="1389" alt="image" src="https://github.com/user-attachments/assets/55f34e01-377e-4a4f-a483-bd0033e89036" />

Utilizes [mnw](https://github.com/Gerg-L/mnw) - Thank you for this!

I wouldn't recommend others to use my configuration, the code can be janky.

Still very much building onto this.

## Testing
```console
nix run github:Soikr/flakevim
```

## Installation
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

## Credits
* [@Gerg-L's](https://github.com/Gerg-L) [nvim-flake](https://github.com/Gerg-L/nvim-flake)
* [@llakala's](https://github.com/llakala) [meowvim](https://github.com/llakala/meovim)
* [@frahz's](https://github.com/frahz) [nvim-flake](https://github.com/frahz/nvim-flake)
