defmodule Valleybot.HttpClientBehaviour do
  @moduledoc false

  @callback get_sender_profile(map()) :: tuple()
end
