defmodule Valleybot.Message.Handler do
  @moduledoc """
  Provides message handlers
  """
  require Logger

  alias Valleybot.Bot
  alias Valleybot.CoinGecko
  alias Valleybot.Message
  alias Valleybot.Message.Templates
  alias Valleybot.Utils

  @max_coins 5
  @type event :: map()

  @spec handle_message(message :: map(), event :: event()) :: :ok | :error
  def handle_message(%{"text" => "hi"}, event) do
    {:ok, profile} = Message.get_sender_profile(event)

    {:ok, first_name} = Map.fetch(profile, "first_name")

    message = "hi #{first_name}. \nWelcome to Valleybot"

    send_message(event, message)

    # We send button template to choose coin search method as
    #
    # Would you like to search coins by?
    #   - Coins ID
    #   - Coins name
    request_coins_search_method(event)
  end

  # Handles message for coin search by ID
  def handle_message(%{"text" => "ID_" <> coin_id}, event) do
    Task.start(fn ->
      message = "Give us a moment, fetching historical price data for #{coin_id} coin"
      send_message(event, message)
    end)

    case CoinGecko.get_market_chart(coin_id) do
      {:ok, historical_data} ->
        prices = Map.get(historical_data, "prices", [])
        prices_string = get_prices_string(prices)

        message =
          if prices == [] do
            "Historical price data not found for coin with id '#{coin_id}', Try again."
          else
            "Historical price data for coin with id '#{coin_id}' for past 14 days. \n\n" <>
              prices_string
          end

        send_message(event, message)

      {:error, _reason} ->
        send_message(event, "Something went wrong, Try again!")
    end
  end

  @doc """
   Handles message for coins search by name
  """
  def handle_message(%{"text" => "CN_" <> query_text}, event) do
    Task.start(fn ->
      message = "Give us a moment, searching coins with '#{query_text}'"
      send_message(event, message)
    end)

    Logger.debug("searching coins with #{query_text}")

    case CoinGecko.search(query_text) do
      {:ok, data} ->
        coins = Map.get(data, "coins", [])
        max_coins = Enum.take(coins, @max_coins)

        # Send title message
        send_message(event, "Select coin from below to see historical prices data from 1 to 5")

        # Send buttons in loop
        Enum.each(max_coins, fn coin ->
          title = """
          Market Capital Rank: #{coin["market_cap_rank"]}
          Symbol: #{coin["symbol"]}
          """

          coin_name = coin["name"]
          payload = "ID_" <> coin["id"]

          button = {:postback, coin_name, payload}

          event
          |> Templates.buttons(title, [button])
          |> Bot.send_message()
        end)

      {:error, _reason} ->
        send_message(event, "Something went wrong, Try again!")
    end
  end

  def handle_message(_message, event) do
    greetings = Message.greeting()

    message = """
    #{greetings}
    Sorry, got unknown message :(
    """

    send_message(event, message)
  end

  @doc """
  Handles postback event
  """
  @spec handle_postback(postback :: map(), event :: event()) :: :ok | :error
  def handle_postback(%{"payload" => "coins_search_by_" <> selected_method}, event) do
    search_guide =
      case selected_method do
        "id" ->
          "Please write Coin ID in format: ID_[coin_id] " <>
            "e.g. ID_bitcoin to get market historical data"

        "name" ->
          "Please write Coins name to search in format: CN_[name] e.g. CN_bitcoin"
      end

    message = "Thank you, for your selection!\n" <> search_guide

    send_message(event, message)
  end

  # Handles postback message for coin historical data
  def handle_postback(%{"payload" => "ID_" <> coin_id, "title" => title}, event) do
    Task.start(fn ->
      message = "Give us a moment, fetching historical price data for #{title} coin"
      send_message(event, message)
    end)

    case CoinGecko.get_market_chart(coin_id) do
      {:ok, historical_data} ->
        prices = Map.get(historical_data, "prices", [])
        prices_string = get_prices_string(prices)

        message =
          if prices == [] do
            "Historical price data not found for '#{title}', Try again."
          else
            "Historical price data for '#{title}' for past 14 days. \n\n" <>
              prices_string
          end

        send_message(event, message)

      {:error, _reason} ->
        send_message(event, "Something went wrong, Try again!")
    end
  end

  defp request_coins_search_method(event) do
    buttons = [
      {:postback, "Coin ID", "coins_search_by_id"},
      {:postback, "Coins name", "coins_search_by_name"}
    ]

    template_title = "Would you like to search coins by?"
    coin_search_method_template = Templates.buttons(event, template_title, buttons)

    # Send postback message
    Bot.send_message(coin_search_method_template)
  end

  defp get_prices_string(prices) do
    Enum.map(prices, fn [date, rate] ->
      date = Utils.Date.to_iso(date)
      rate = Utils.Currency.roundoff(rate)

      "#{date}: $#{rate}"
    end)
    |> Enum.join("\n")
  end

  defp send_message(event, message) do
    event
    |> Templates.text(message)
    |> Bot.send_message()
  end
end
