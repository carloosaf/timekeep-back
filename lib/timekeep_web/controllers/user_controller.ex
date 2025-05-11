defmodule TimekeepWeb.UserController do
  use TimekeepWeb, :controller

  alias Timekeep.Users
  alias TimekeepWeb.Dtos.UpdateUser
  import Timekeep.Utils

  action_fallback TimekeepWeb.FallbackController

  def show(conn, _params) do
    with {:ok, user} <- Users.get_user(conn.assigns.current_user) do
      render(conn, :show, user: user)
    end
  end

  def update(conn, %{"user" => user_params}) do
    with :ok <- UpdateUser.changeset(%UpdateUser{}, user_params) |> validate_dto(),
         {:ok, user} <- Users.update_user(conn.assigns.current_user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, _params) do
    with :ok <- Users.delete_user(conn.assigns.current_user) do
      send_resp(conn, :no_content, "")
    end
  end
end
