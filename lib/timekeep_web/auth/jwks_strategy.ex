defmodule TimekeepWeb.Auth.JwksStrategy do
  use JokenJwks.DefaultStrategyTemplate

  def init_opts(opts) do
    Keyword.merge(opts,
      jwks_url: Application.get_env(:timekeep, TimekeepWeb.Auth.JwksStrategy)[:jwks_url]
    )
  end
end
