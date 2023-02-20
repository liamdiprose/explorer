{ lib,
  buildRustPackage,
  # zstd,
  # lz4,
  act,
  clang,
  gdb,
  libiconv,
  openssl,
  pkg-config
}:

buildRustPackage {
  pname = "elixir-explorer-native";
  version = "0.1.0";

  DEBUGLEVEL = "5";

  buildInputs = [
    act
    clang
    gdb
    libiconv
    openssl
    pkg-config
  ];

  src = ./native/explorer;
  cargoLock = {
    lockFile = ./native/explorer/Cargo.lock;
    outputHashes = {
      "rustler-0.26.0" = "AesXKLSu4KgLj+wLx7uzJGN/ovXi9VxAbXlLGq0AidY=";
    };
   };

   doCheck = false;
 }
