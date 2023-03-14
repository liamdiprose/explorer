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
  version = "0.5.0";

  inherit elixir;

  src = ./.;

  beamDeps = [
    rustler
    rustler_precompiled
    table
    table_rex
    toml
  ];

  buildInputs = [ nativePkg ];

  postInstall = ''
    RUSTLER_LOAD_DIR=$out/lib/erlang/lib/explorer-0.5.0/priv/native
    mkdir -p $RUSTLER_LOAD_DIR
    ln -s ${nativePkg}/lib/libexplorer.so $RUSTLER_LOAD_DIR
  '';
}
