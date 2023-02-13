defmodule Valleybot.Message do
  @moduledoc """
  The Message Module

  Handles exchange of messages between the bot and a facebook user
  """
  alias Valleybot.HttpClient

  @type event :: map()

  @doc """
  Returns sender profile

  A sender in the context of this application is a facebook user chatting with the bot.
  """
  @spec get_sender_profile(event :: event()) :: {:ok, any()} | {:profile_not_found, any()}
  def get_sender_profile(event) do
    sender = get_sender(event)

    HttpClient.get_sender_profile(sender)
  end

  @spec get_sender(event :: event()) :: map()
  def get_sender(event) do
    messaging = get_messaging(event)

    messaging["sender"]
  end

  @spec get_recipient(event :: event()) :: map()
  def get_recipient(event) do
    messaging = get_messaging(event)

    messaging["recipient"]
  end

  @spec get_message(event :: event()) :: map()
  def get_message(event) do
    messaging = get_messaging(event)

    messaging["message"]
  end

  @spec get_messaging(event :: event()) :: map()
  def get_messaging(event) when is_map(event) do
    [entry | _other] = event["entry"]
    [messaging | _other] = entry["messaging"]

    messaging
  end

  @spec greeting() :: String.t()
  def greeting do
    """
    Hi :)
    Welcome to Valleybot
    """
  end
end
