defmodule TimekeepWeb.Dtos.UpdateUser do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :email, :string
    field :username, :string
    field :first_name, :string
    field :last_name, :string
  end

  # TODO: check clerks validation for username etc...
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:email, :username, :first_name, :last_name])
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/)
  end
end
