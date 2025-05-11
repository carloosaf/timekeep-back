defmodule TimekeepWeb.Auth.Token do
  use Joken.Config, default_signer: nil

  add_hook(JokenJwks, strategy: TimekeepWeb.Auth.JwksStrategy)

  @impl true
  def token_config do
    default_claims(skip: [:aud, :iss])
  end
end
