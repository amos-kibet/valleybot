import Config

# Facebook messenger's bot configuration
FB_PAGE_ACCESS_TOKEN =
  System.get_env("FB_PAGE_ACCESS_TOKEN") ||
    raise """
    environment variable FB_PAGE_ACCESS_TOKEN missing
    """

FB_WEBHOOK_VERIFY_TOKEN =
  System.get_env("FB_WEBHOOK_VERIFY_TOKEN") ||
    raise """
    environment variable FB_WEBHOOK_VERIFY_TOKEN missing
    """

config :valleybot,
  fb_config: %{
    api_version: "v16.0",
    message_url: "me/messages",
    base_url: "https://graph.facebook.com",
    page_access_token: FB_PAGE_ACCESS_TOKEN,
    webhook_verify_token: FB_WEBHOOK_VERIFY_TOKEN
  }

# Coin Geck API configuration
config :valleybot,
  coin_gecko: %{
    api_version: "v3",
    base_url: "https://api.coingecko.com/api"
  }

# HTTP client configuration
config :valleybot, http_client: Valleybot.HttpClient

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :valleybot, ValleybotWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4003],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "0nNaUlhFgjJCMCXzZ8Z5fM6fjwPyLFUgdm6k4VvBCmlyob+o5VmBsgfk9qazLMjz",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :valleybot, ValleybotWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/valleybot_web/(live|views)/.*(ex)$",
      ~r"lib/valleybot_web/templates/.*(eex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :valleybot, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
