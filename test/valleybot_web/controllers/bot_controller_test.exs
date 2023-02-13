defmodule ValleybotWeb.BotControllerTest do
  use ValleybotWeb.ConnCase

  require Logger

  import ExUnit.CaptureLog
  import ValleybotWeb.BotController
  import Valleybot.Fixtrues.EventFixture

  @event event_fixture()
  @valid_params %{
    "hub.mode" => "subscribe",
    "hub.verify_token" => "valley_bot",
    "hub.challenge" => 1_000_000
  }

  @invalid_params %{
    "hub.mode" => "subscribe",
    "hub.verify_token" => "invalid_token",
    "hub.challenge" => 1_000_000
  }

  describe "Verify Facebook Webhook Token" do
    test "GET /api/webhook should verify successfully with valid verify_token", %{conn: conn} do
      params = @valid_params

      conn = get(conn, ~p"/api/webhook", params)

      assert json_response(conn, 200)

      # verify challenge
      assert json_response(conn, 200) == params["hub.challenge"]
    end

    # @FIXME: the test below raises:
    #  `(FunctionClauseError) no function clause matching in Plug.Conn.resp/3`
    #
    # test "GET /api/webhook should log info message when it successfully verifies webhook", %{
    #   conn: conn
    # } do
    #   params = @valid_params

    #   {_result, log} = with_log(fn -> verify(conn, params) end)
    #   assert log =~ "Webhook Verified!"
    # end

    test "GET /api/webhook should fail to verify with invalid verify_token", %{conn: conn} do
      params = @invalid_params

      conn = get(conn, ~p"/api/webhook", params)

      assert json_response(conn, 403)

      # assert json serialization
      assert json_response(conn, 403) == %{"status" => "error", "message" => "unauthorized"}
    end

    test "GET /api/webhook should log error message when it fails to verify webhook", %{
      conn: conn
    } do
      params = @invalid_params

      {_result, log} = with_log(fn -> verify(conn, params) end)
      assert log =~ "Client Not Verified!"
    end

    test "verify/1 should return true for a valid verify_token" do
      params = @valid_params

      assert verify(params) == true
    end

    test "verify/1 should return false for an invalid verify_token" do
      params = @invalid_params

      assert verify(params) == false
    end
  end

  describe "Handle Webhook POST Events" do
    test "handle_event/2 should log info message when it handles an event", %{conn: conn} do
      {_result, log} = with_log(fn -> handle_event(conn, @event) end)

      assert log =~ "Webhook Event Received!"
    end
  end
end
