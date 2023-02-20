{
  description = "Explorer";

  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, fenix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ fenix.overlays.default ];
        pkgs = import nixpkgs { inherit overlays system; };
        toolchain = "latest";
        rustPkg = fenix.packages.${system}.${toolchain}.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ];

        buildRustPackage = (pkgs.makeRustPlatform {
          cargo = rustPkg;
          rustc = rustPkg;
        }).buildRustPackage;

        beamPackages = pkgs.beam.packages.erlangR25;
        elixir = pkgs.beamPackages.elixir_1_14;
        erlang = pkgs.erlangR25;
      in
      {
        packages = rec {
          native = pkgs.callPackage ./native.nix {
            inherit buildRustPackage;
          };
          default = pkgs.callPackage ./default.nix {
            inherit elixir beamPackages;
            nativePkg = native;
          };
        };

        lib.buildPackage = {elixir, beamPackages, pkgs}:
          let
            native = pkgs.callPackage ./native.nix {
              inherit buildRustPackage;
            };
          in pkgs.callPackage ./default.nix {
              nativePkg = native;
              inherit elixir beamPackages;
            };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            elixir
            erlang
            act
            clang
            gdb
            libiconv
            openssl
            pkg-config
            rustPkg
            rust-analyzer-nightly
            mix2nix
          ] ++ lib.optionals stdenv.isDarwin [
            darwin.apple_sdk.frameworks.Security
          ];
          shellHook = ''
            mkdir -p .nix-mix
            mkdir -p .nix-hex
            export MIX_HOME=$PWD/.nix-mix
            export HEX_HOME=$PWD/.nix-hex
            export PATH=$MIX_HOME/bin:$PATH
            export PATH=$HEX_HOME/bin:$PATH
            export PATH=$MIX_HOME/escripts:$PATH
          '';
        };
      });
}
