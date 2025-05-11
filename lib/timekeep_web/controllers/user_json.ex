defmodule TimekeepWeb.UserJSON do
  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%{
         id: id,
         email: email,
         username: username,
         first_name: first_name,
         last_name: last_name
       }) do
    %{
      id: id,
      email: email,
      username: username,
      first_name: first_name,
      last_name: last_name
    }
  end
end
