defmodule Valleybot.BotTest do
  @moduledoc false

  use ExUnit.Case, async: true

  require Logger

  import ExUnit.CaptureLog

  alias Valleybot.Bot
  alias Valleybot.Fixtrues.EventFixture

  @valid_event EventFixture.event_fixture()
  @invalid_event "invalid"

  @valid_body %{
    "message" => %{"text" => "hi Moss. \nWelcome to Valleybot"},
    "recipient" => %{"id" => "5849869351764383"}
  }

  describe "Bot Context" do
    test "handle_event/1 should return :ok with a correct event" do
      assert Bot.handle_event(@valid_event) == :ok
    end

    test "handle_event/1 should raise an error with an incorrect event data type" do
      assert_raise(
        FunctionClauseError,
        "no function clause matching in Valleybot.Bot.handle_event/1",
        fn -> Bot.handle_event(@invalid_event) end
      )
    end

    test "send_message/1 should return :ok and log info message when provided with a correct body" do
      {result, log} = with_log(fn -> Bot.send_message(@valid_body) end)

      assert result == :ok
      assert log =~ "Message sent to facebook user"
    end
  end
end
