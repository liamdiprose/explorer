{ lib,
  buildRustPackage,
  # zstd,
  # lz4,
  elixir,
  act,
  clang,
  gdb,
  libiconv,
  openssl,
  pkg-config
}:

buildRustPackage {
  pname = "elixir-explorer-native";
  version = "0.5.0";

  buildInputs = [
    act
    clang
    gdb
    libiconv
    openssl
    pkg-config
  ];

  RUSTLER_NIF_VERSION = "2.16";

  postConfigure = ''
    ${elixir}/bin/elixir -e 'IO.puts("DETECTED NIF VERSION: #{:erlang.system_info(:nif_version)}")'
    export RUSTLER_NIF_VERSION
  '';


  src = ./native/explorer;
  cargoLock = {
    lockFile = ./native/explorer/Cargo.lock;
    outputHashes = {
      "rustler-0.26.0" = "AesXKLSu4KgLj+wLx7uzJGN/ovXi9VxAbXlLGq0AidY=";
    };
   };

   doCheck = false;
 }
