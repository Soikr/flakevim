{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "blink.cmp";
  version = "1.6.0-unstable-2025-08-06";

  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.cmp";
    rev = "ce26f9fbaa4560440dd981cad1d2e47ae82dd3a6";
    hash = "sha256-WeTb73URNOfCPZkRp3hWueF+jIJtN9nZ/dNKEt+yku4=";
  };

  cargoHash = "sha256-QsVCugYWRri4qu64wHnbJQZBhy4tQrr+gCYbXtRBlqE=";

  # Tries to call git
  preBuild = ''
    rm build.rs
  '';

  postInstall = ''
    cp -r {lua,plugin} "$out"
    mkdir -p "$out/doc"
    cp 'doc/'*'.txt' "$out/doc/"
    mkdir -p "$out/target"
    mv "$out/lib" "$out/target/release"
  '';

  # Uses rust nightly
  env.RUSTC_BOOTSTRAP = true;
  # Don't move /doc to $out/share
  forceShare = [ ];
}
