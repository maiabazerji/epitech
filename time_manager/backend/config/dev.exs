import Config

# Import Dotenv for environment variable loading (if you still want to use it)
Dotenv.load()

# Configure your database
config :time_manager, TimeManager.Repo,
  username: System.get_env("POSTGRES_USER", "postgres"),    
  password: System.get_env("POSTGRES_PASSWORD", "postgres"),
  database: System.get_env("POSTGRES_DB", "timemanagerapp"),
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  port: System.get_env("POSTGRES_PORT", "5432") |> String.to_integer(),
  pool_size: 10,
  show_sensitive_data_on_connection_error: true

# Configure the web endpoint
config :time_manager, TimeManagerWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "nqmipFfRmntuoHasGawgupU/qiyTSYAijhqCTAKEwQJ4OgPltPcszL4KUb53Zsvq"

# Enable dev routes for dashboard and mailbox
config :time_manager, dev_routes: true

# Logging configuration
config :logger, :console, format: "[$level] $message\n"

# Development-specific settings
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
