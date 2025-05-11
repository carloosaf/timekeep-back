defmodule Timekeep.Users do
  @moduledoc """
  The Users context.
  """
  @doc """
    Generates a Req.Request object with the Clerk API key and URL.
  """
  def clerk_request(method, path, body \\ %{}) do
    clerk_api_url = Application.fetch_env!(:timekeep, Timekeep.Users)[:clerk_api_url]
    clerk_api_key = Application.fetch_env!(:timekeep, Timekeep.Users)[:clerk_api_key]

    Req.new(
      method: method,
      url: clerk_api_url <> path,
      json: body,
      auth: {:bearer, clerk_api_key}
    )
  end

  @doc """
    Gets a user by id.

    ## Examples

        iex> get_user("example id")
        {:ok, %{id: 1, email: "user@example.com", username: "user", first_name: "User", last_name: "Example"}}
        iex> get_user("invalid id")
        {:error, :not_found}
  """
  def get_user(id) do
    {_request, response} =
      clerk_request(:get, "users/#{id}")
      |> Req.run()

    case response.status do
      200 ->
        {:ok,
         %{
           id: response.body["id"],
           email: response.body["email"],
           username: response.body["username"],
           first_name: response.body["first_name"],
           last_name: response.body["last_name"]
         }}

      404 ->
        {:error, :not_found}

      _ ->
        {:error, :unexpected_response}
    end
  end

  @doc """
    Updates a user

    ## Examples

        iex> update_user("example id", %{email: "new@example.com"})
        {:ok, %{id: 1, email: "new@example.com", username: "user", first_name: "User", last_name: "Example"}}
        iex> update_user("invalid id", %{email: "new@example.com"})
        {:error, :not_found}
  """
  def update_user(id, user_params) do
    {_request, response} =
      clerk_request(:patch, "users/#{id}", user_params)
      |> Req.run()

    dbg(response)

    case response.status do
      200 ->
        {:ok,
         %{
           id: response.body["id"],
           email: response.body["email"],
           username: response.body["username"],
           first_name: response.body["first_name"],
           last_name: response.body["last_name"]
         }}

      404 ->
        {:error, :not_found}

      _ ->
        {:error, :unexpected_response}
    end
  end

  @doc """
    Deletes a user

    ## Examples

        iex> delete_user("example id")
        :ok
        iex> delete_user("invalid id")
        {:error, :not_found}
  """
  def delete_user(id) do
    {_request, response} =
      clerk_request(:delete, "users/#{id}")
      |> Req.run()

    case response.status do
      200 ->
        :ok

      404 ->
        {:error, :not_found}

      _ ->
        {:error, :unexpected_response}
    end
  end
end
