import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :valleybot, ValleybotWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "OfQdDnqZrC5S5c5GQ4xe6kUs48UZVtKAh/RVXGTEStQECHetM9zMEQFbGNOR4O3v",
  server: false

# In test we don't send emails.
config :valleybot, Valleybot.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print info, warnings and errors during test, in order to test captured logs
config :logger, level: :info

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

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
config :valleybot, http_client: Valleybot.HttpClientMock
