defmodule Valleybot.Utils.TeslaClient do
  @moduledoc """
  Provides helpers to build tesla client with dynamic configuration
  """
  @recv_timeout 30_000

  @doc """
  returns a tesla client for specified configuration
  """
  @spec client(:coin_gecko | :messenger | nil, timeout :: non_neg_integer()) :: Tesla.Client.t()
  def client(type, timeout \\ @recv_timeout)

  def client(type, timeout) when type == :coin_gecko do
    coin_gecko = Application.get_env(:valleybot, :coin_gecko)
    base_url = coin_gecko.base_url <> "/" <> coin_gecko.api_version
    new(base_url, timeout)
  end

  def client(type, timeout) when type == :messenger do
    fb_config = Application.get_env(:valleybot, :fb_config)
    base_url = fb_config.base_url <> "/" <> fb_config.api_version
    new(base_url, timeout)
  end

  def client(type, timeout) when type == nil do
    Tesla.client(
      [
        {Tesla.Middleware.JSON, engine: Jason},
        {Tesla.Middleware.Timeout, timeout: timeout}
      ],
      {
        Tesla.Adapter.Hackney,
        ssl_options: [verify: :verify_none], recv_timeout: timeout
      }
    )
  end

  # Builds tesla client with runtime arguments
  defp new(base_url, timeout) do
    Tesla.client(
      [
        {Tesla.Middleware.BaseUrl, base_url},
        {Tesla.Middleware.JSON, engine: Jason},
        {Tesla.Middleware.Timeout, timeout: timeout}
      ],
      {
        Tesla.Adapter.Hackney,
        ssl_options: [verify: :verify_none], recv_timeout: timeout
      }
    )
  end
end
