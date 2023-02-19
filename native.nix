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
       "zstd-0.11.2+zstd.1.5.2" = "LFDR6c0LiLLqpOzFA5A2WhiH2/ig5Z33uhmJ+lbM5z0=";
     };
   };

   doCheck = false;
 }
