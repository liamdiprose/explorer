{ lib,
  elixir,
  beamPackages,
  nativePkg
}:

let
  mixNixDeps = import ./mix_deps.nix {
    inherit lib;
    inherit elixir;
    inherit beamPackages;
  };
in beamPackages.buildMix {
  name = "explorer";
  version = "0.5.5";

  inherit elixir;

  src = ./.;

  beamDeps = with mixNixDeps; [
    rustler
    # rustler_precompiled
    table
    table_rex
    toml
  ];

  # postInstall = ''
  #   cp ${nativePkg}/lib/libexplorer.so $out/lib/libexplorer.so
  # '';
}
