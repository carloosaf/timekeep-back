defmodule Timekeep.Repo do
  use Ecto.Repo,
    otp_app: :timekeep,
    adapter: Ecto.Adapters.Postgres
end
