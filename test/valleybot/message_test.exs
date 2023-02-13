defmodule Valleybot.MessageTest do
  use ExUnit.Case, async: true

  alias Valleybot.Message
  import Valleybot.Fixtrues.EventFixture

  @valid_event event_fixture()
  @invalid_event nil

  describe "Message Context" do
    test "get_sender_profile/1 returns sender_profile when given correct event" do
      {:ok, profile} = Message.get_sender_profile(@valid_event)

      assert is_map(profile)
      assert profile["first_name"] == "Moss"
      assert profile["last_name"] == "Kirui"
      assert profile["id"] == "5849869351764383"
    end

    test "get_sender_profile/1 raises error when given incorrect event data structure" do
      assert_raise(
        FunctionClauseError,
        "no function clause matching in Valleybot.Message.get_messaging/1",
        fn -> Message.get_sender_profile(@invalid_event) end
      )
    end

    test "get_sender/1 returns sender information as a map, given correct event" do
      sender = Message.get_sender(@valid_event)

      assert is_map(sender)
      assert Map.has_key?(sender, "id")
      assert sender["id"] == "5849869351764383"
    end

    test "get_sender/1 raises error when given incorrect event data structure" do
      assert_raise(
        FunctionClauseError,
        "no function clause matching in Valleybot.Message.get_messaging/1",
        fn -> Message.get_sender(@invalid_event) end
      )
    end

    test "get_recipient/1 returns recipient information as a map, given correct event" do
      recipient = Message.get_recipient(@valid_event)

      assert is_map(recipient)
      assert Map.has_key?(recipient, "id")
      assert recipient["id"] == "117083251294443"
    end

    test "get_recipient/1 raises error when given incorrect event data structure" do
      assert_raise(
        FunctionClauseError,
        "no function clause matching in Valleybot.Message.get_messaging/1",
        fn -> Message.get_recipient(@invalid_event) end
      )
    end

    test "get_message/1 returns message information as a map, given correct event" do
      message = Message.get_message(@valid_event)

      assert is_map(message)
      assert Map.has_key?(message, "text")
      assert message["text"] == "hi"

      assert Map.has_key?(message, "mid")

      assert message["mid"] ==
               "m_FqlE5fo2oHbq_uJl7rDHiI0cSqrbhbiMl0l9I-DQ7rqXXZ-56IgyJZJJj86bMnC5POArcHLLDy-QC3zG-glUQg"

      assert Map.has_key?(message, "nlp")
      assert is_map(message["nlp"])
    end

    test "get_message/1 raises error when given incorrect event data structure" do
      assert_raise(
        FunctionClauseError,
        "no function clause matching in Valleybot.Message.get_messaging/1",
        fn -> Message.get_recipient(@invalid_event) end
      )
    end

    test "get_messaging/1 returns messaging information as a map, given correct event" do
      messaging = Message.get_messaging(@valid_event)

      assert is_map(messaging)
      assert Map.has_key?(messaging, "message")
    end

    test "get_messaging/1 raises error when given incorrect event data structure" do
      assert_raise(
        FunctionClauseError,
        "no function clause matching in Valleybot.Message.get_messaging/1",
        fn -> Message.get_messaging(@invalid_event) end
      )
    end

    test "greeting/0 returns a greeting" do
      greeting = Message.greeting()

      assert is_binary(greeting)

      assert greeting == """
             Hi :)
             Welcome to Valleybot
             """
    end
  end
end
