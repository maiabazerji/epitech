import Config

# Load environment variables from the .env file
Dotenv.load()

if File.exists?(".env") do
  File.read!(".env")
  |> String.split("\n")
  |> Enum.each(fn line ->
    case String.split(line, "=") do
      [key, value] -> System.put_env(String.trim(key), String.trim(value))
      _ -> nil
    end
  end)
end

# Configure your application
config :time_manager,
  ecto_repos: [TimeManager.Repo],
  generators: [timestamp_type: :utc_datetime]

config :time_manager, TimeManager.Repo,
  username: System.get_env("POSTGRES_USER", "postgres"),
  password: System.get_env("POSTGRES_PASSWORD", "postgres"),
  database: System.get_env("POSTGRES_DB", "timemanagerapp"),
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  port: String.to_integer(System.get_env("POSTGRES_PORT", "5432")),
  pool_size: 10,
  show_sensitive_data_on_connection_error: true

config :time_manager, TimeManagerWeb.Endpoint,
  url: [host: System.get_env("PHOENIX_HOST", "localhost")],
  http: [port: String.to_integer(System.get_env("PHOENIX_PORT", "4000"))],
  http: [ip: {0, 0, 0, 0}, port: String.to_integer(System.get_env("PHOENIX_PORT", "4000"))],
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
