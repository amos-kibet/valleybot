defmodule Valleybot.CoinGeckoTest do
  use ExUnit.Case, async: true

  alias Valleybot.CoinGecko

  @currency "usd"
  @days_ago 13
  @data_interval "daily"
  @coin_id "0x"

  describe "CoinGecko Context" do
    test "search/1 returns a result, given a valid query string" do
      assert {:ok, result} = CoinGecko.search("anything, really")
      assert is_map(result)
    end

    test "search/1 returns error, given an invalid query string" do
      assert {:error, error} = CoinGecko.search(nil)
      assert error == "invalid search text."
    end

    test "search/1 returns error, given an invalid query string data structure" do
      assert {:error, error} = CoinGecko.search(%{"query" => "invalid"})

      assert error == "invalid search text."
    end

    test "get_by_id/1 returns a result, given a valid query ID" do
      assert {:ok, result} = CoinGecko.get_by_id("1")
      assert is_map(result)
    end

    test "get_by_id/1 returns error, given an invalid query ID" do
      assert {:error, error} = CoinGecko.get_by_id(1)
      assert is_binary(error)
      assert error == "invalid coin id."
    end

    test "get_market_chart/4 returns a result, given valid arguments" do
      {:ok, result} = CoinGecko.get_market_chart(@coin_id, @currency, @days_ago, @data_interval)

      assert is_map(result)
      assert Map.has_key?(result, "market_caps")
    end

    test "get_market_chart/4 returns result, which is an error map, given valid arguments, but invalid coin ID" do
      {:ok, result} = CoinGecko.get_market_chart("1", @currency, @days_ago, @data_interval)

      assert is_map(result)

      assert Map.has_key?(result, "error")
      assert Map.get(result, "error") == "coin not found"
    end

    test "get_market_chart/4 returns error tuple, given invalid arguments" do
      assert {:error, error} = CoinGecko.get_market_chart(nil, nil, nil, nil)

      assert is_binary(error)

      assert error == "invalid coin id."
    end
  end
end
