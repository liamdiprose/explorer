{ lib,
  elixir,
  beamPackages,
  nativePkg,
  symlinkJoin
}:

let
  mixNixDeps = import ./mix_deps.nix {
    inherit lib;
    inherit elixir;
    inherit beamPackages;
  };
  elixirPkg = beamPackages.buildMix {
    name = "elixir-explorer-mix";
    version = "0.5.5";

    inherit elixir;

    src = ./.;

    beamDeps = with mixNixDeps; [
      rustler
      rustler_precompiled
      table
      table_rex
      toml
    ];

    propagatedBuildInputs = [
      nativePkg
    ];
  };
in
  symlinkJoin {
    name = "elixir-explorer";
    paths = [
      nativePkg
      elixirPkg
    ];
  }

