{ buildMix, elixir, rustler, rustler_precompiled, table, table_rex, toml, rustPkg }:

buildMix {
  name = "explorer";
  version = "0.5.5";

  inherit elixir;

  preConfigure = ''
    pwd
    ls
  '';

  src = ./.;

  beamDeps = [
    rustler
    rustler_precompiled
    table
    table_rex
    toml
  ];

  nativeBuildInputs = [
    rustPkg
  ];
}
