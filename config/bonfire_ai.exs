import Config

config :bonfire_ai,
  templates_path: "lib"

config :nx, default_backend: EXLA.Backend
