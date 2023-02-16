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

        beamPackages = pkgs.beam.packages.erlangR25;
        elixir = pkgs.beamPackages.elixir_1_14;
        erlang = pkgs.erlangR25;
        mixNixDeps = import ./mix_deps.nix {
          inherit (pkgs) lib;
          inherit elixir;
          inherit beamPackages;
        };
      in
      {
        packages.default = pkgs.callPackage ./default.nix {
          inherit elixir;
          inherit (beamPackages) buildMix;
          inherit (mixNixDeps) rustler rustler_precompiled table table_rex toml;
          inherit rustPkg;
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
