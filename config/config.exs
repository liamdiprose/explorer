import Config

config :explorer, :check_polars_frames, false

config :explorer, Explorer.PolarsBackend.Native,
  skip_compilation?: true,
  load_from: "nix_rust_lib"
