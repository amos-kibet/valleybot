defmodule Valleybot.HttpClient do
  @moduledoc false

  require Logger

  alias Valleybot.Utils.TeslaClient

  @behaviour Valleybot.HttpClientBehaviour

  @doc """
  Makes the actual http requests to the facebook graph api

  Returns sender's profile when provided with sender's id.
  """
  def get_sender_profile(sender) do
    messenger = Application.get_env(:valleybot, :fb_config)

    sender_id = sender["id"]

    client = TeslaClient.client(:messenger)

    case Tesla.get(client, sender_id, query: [access_token: messenger.page_access_token]) do
      {:ok, response} ->
        if Map.has_key?(response.body, "first_name") do
          Logger.info("Sender profile found!")
          {:ok, response.body}
        else
          Logger.error("Application does not have the capability to make this API call.")
          {:error, :fb_oauth_exception}
        end

      {:error, reason} ->
        Logger.warn("Sender profile not found!")
        {:profile_not_found, reason}
    end

    # @TODO: setup finch, using below code👇
    # url = process_url()

    # result =
    #   Finch.build(:get, url)
    #   |> Finch.request(Valleybot.Finch)

    # case result do
    #   {:ok, %Finch.Response{} = response} ->
    #     if response.status == 200 do
    #       Logger.info("Sender profile found!")

    #       response
    #       |> Map.get(:body)
    #       |> Jason.decode()
    #     else
    #       Logger.warn("Sender profile not found!")
    #       {:error, :not_found}
    #     end

    #   {:error, _error} ->
    #     Logger.error("Something went wrong on the server!")
    #     {:error, :finch_error}
    # end
  end

  # def process_url do
  #   fb_config = Application.get_env(:valleybot, :fb_config)

  #   base_url = fb_config.base_url
  #   api_version = fb_config.api_version
  #   message_url = fb_config.message_url

  #   base_url <> "/" <> api_version <> "/" <> message_url
  # end
end
