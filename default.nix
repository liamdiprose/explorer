{ lib,
  elixir,
  buildMix,
  nativePkg,
  rustler,
  rustler_precompiled,
  table,
  table_rex,
  toml
}:
buildMix {
  name = "explorer";
  version = "0.5.5";

  inherit elixir;

  src = ./.;

  beamDeps = [
    rustler
    rustler_precompiled
    table
    table_rex
    toml
  ];

  # postInstall = ''
  #   cp ${nativePkg}/lib/libexplorer.so $out/lib/libexplorer.so
  # '';
}
