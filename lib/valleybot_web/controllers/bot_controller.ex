defmodule ValleybotWeb.BotController do
  @moduledoc """
  Handles incoming HTTP requests

  Requests are `GET` and `POST`

  `GET` requests are requests that a Facebook app's webhook sends each time to verify itself

  The app sends the following in order to be verified:

    `hub.mode`: "subscribe",
    `hub.verify_token`: a random string that you set when creating your app on facebook. You must set it as well in your server's (server in this case is the bot) config
                      : example: "random_string"
    `hub.challenge`: an integer value that your fscebook app or any http client sends to the server as part of verification process. If your app is verified, the server returns this number as part of the response.

  `POST` requests are requests sent by your facebook app's webhook.

  The webhook requests are sent each time a user interacts with your server (bot).
  """
  use ValleybotWeb, :controller

  require Logger

  @doc """
  Verifies that an incoming http client's `hub.verify_token` value matches the `verify_token` value set in your facebook app's webhook settings

  Responds with the same `hub.challenge` value that the request sent
  """
  @spec verify(conn :: Plug.Conn.t(), params :: nil | maybe_improper_list() | map()) ::
          Plug.Conn.t()
  def verify(conn, params) do
    verified? = verify(params)

    if verified? do
      Logger.info("Webhook Verified!")

      response = params["hub.challenge"]

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, response)
    else
      Logger.warn("Client Not Verified!")

      response = Jason.encode!(%{status: "error", message: "unauthorized"})

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, response)
    end
  end

  @doc """
  Handles events sent by facebook app's webhook

  Events that we are concerned with are messages being sent to our bot by a facebook user.

  Returns a conn struct that contains:

    - `body`: required, and in the form of: `{"status": "ok"}
  """
  @spec handle_event(conn :: Plug.Conn.t(), event :: nil | maybe_improper_list() | map()) ::
          Plug.Conn.t()
  def handle_event(conn, event) do
    Logger.info("Webhook Event Received!")

    Valleybot.Bot.handle_event(event)

    response = Jason.encode!(%{status: "ok"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  @doc """
  Verifies mode & token received from facebook app's webhook events

  Returns true or false
  """
  @spec verify(params :: nil | maybe_improper_list() | map()) :: boolean()
  def verify(params) do
    fb_config = Application.get_env(:valleybot, :fb_config)
    verify_token = fb_config[:webhook_verify_token]

    mode = params["hub.mode"]
    token = params["hub.verify_token"]

    mode == "subscribe" && token == verify_token
  end
end
