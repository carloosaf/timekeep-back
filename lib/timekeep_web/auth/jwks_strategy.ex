defmodule TimekeepWeb.Auth.JwksStrategy do
  use JokenJwks.DefaultStrategyTemplate

  def init_opts(opts) do
    Keyword.merge(opts,
      jwks_url: "https://fancy-cougar-61.clerk.accounts.dev/.well-known/jwks.json"
    )
  end
end
