defmodule Valleybot.Bot do
  @moduledoc false
  require Logger

  alias Valleybot.Bot
  alias Valleybot.Message
  alias Valleybot.Utils.TeslaClient

  @spec handle_event(event :: nil | maybe_improper_list() | map()) :: :ok | :error
  def handle_event(event) when is_map(event) do
    case Message.get_messaging(event) do
      %{"message" => message} ->
        Message.Handler.handle_message(message, event)

      %{"postback" => postback} ->
        Message.Handler.handle_postback(postback, event)

      _ ->
        error_body = Message.Templates.text(event, "Something went wrong. Try again!")

        Bot.send_message(error_body)
    end
  end

  @doc """
  Sends message to facebook user (sender in the context of this application)
  """
  @spec send_message(body :: map()) :: :ok | :error
  def send_message(body) do
    messenger = Application.get_env(:valleybot, :fb_config)

    client = TeslaClient.client(:messenger)

    case Tesla.post(client, messenger.message_url, body,
           query: [access_token: messenger.page_access_token],
           headers: [{"content-type", "application/json"}]
         ) do
      {:ok, _resp} ->
        Logger.info("Message sent to facebook user")

      {:error, reason} ->
        Logger.error("Unable to send message to facebook user \n #{inspect(reason)}")
        :error
    end
  end
end
