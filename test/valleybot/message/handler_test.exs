defmodule Valleybot.Message.HandlerTest do
  use ExUnit.Case, async: true

  import Valleybot.Fixtrues.EventFixture

  alias Valleybot.Message.Handler

  @valid_event event_fixture()
  @valid_payload_1 %{"payload" => "coins_search_by_id"}
  @valid_payload_2 %{"payload" => "coins_search_by_name"}

  describe "Message Handlers" do
    test "handle_message/2 returns :ok, given the text 'hi', and a correct event" do
      result = Handler.handle_message(%{"text" => "hi"}, @valid_event)

      assert result == :ok
    end

    test "handle_message/2 returns :ok, given a coin id in the form of ID_, and a correct event" do
      result = Handler.handle_message(%{"text" => "ID_0x"}, @valid_event)

      assert result == :ok
    end

    test "handle_message/2 returns :ok, given a coin name in the form of CN_, and a correct event" do
      result = Handler.handle_message(%{"text" => "CN_0x"}, @valid_event)

      assert result == :ok
    end

    test "handle_message/2 returns :ok, given any argument, and a correct event" do
      result = Handler.handle_message(nil, @valid_event)

      assert result == :ok
    end
  end

  describe "Postback Handlers" do
    test "handle_postback/2 returns :ok, when given 'id', and correct event" do
      result = Handler.handle_postback(@valid_payload_1, @valid_event)

      assert result == :ok
    end

    test "handle_postback/2 returns :ok, when given 'name', and correct event" do
      result = Handler.handle_postback(@valid_payload_2, @valid_event)

      assert result == :ok
    end
  end
end
