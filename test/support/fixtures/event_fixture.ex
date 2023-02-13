defmodule Valleybot.Fixtrues.EventFixture do
  @moduledoc """
  Facebook events mock module

  Contains a function that returns a mock facebook webhook event
  """

  def event_fixture do
    %{
      "entry" => [
        %{
          "id" => "117083251294443",
          "messaging" => [
            %{
              "message" => %{
                "mid" =>
                  "m_FqlE5fo2oHbq_uJl7rDHiI0cSqrbhbiMl0l9I-DQ7rqXXZ-56IgyJZJJj86bMnC5POArcHLLDy-QC3zG-glUQg",
                "nlp" => %{
                  "detected_locales" => [
                    %{"confidence" => 0.7311, "locale" => "hi_IN"}
                  ],
                  "entities" => %{},
                  "intents" => [],
                  "traits" => %{
                    "wit$greetings" => [
                      %{
                        "confidence" => 0.9999,
                        "id" => "5900cc2d-41b7-45b2-b21f-b950d3ae3c5c",
                        "value" => "true"
                      }
                    ],
                    "wit$sentiment" => [
                      %{
                        "confidence" => 0.7336,
                        "id" => "5ac2b50a-44e4-466e-9d49-bad6bd40092c",
                        "value" => "positive"
                      }
                    ]
                  }
                },
                "text" => "hi"
              },
              "recipient" => %{"id" => "117083251294443"},
              "sender" => %{"id" => "5849869351764383"},
              "timestamp" => 1_676_135_308_039
            }
          ],
          "time" => 1_676_137_042_480
        }
      ],
      "object" => "page"
    }
  end
end
