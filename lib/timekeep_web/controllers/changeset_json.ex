defmodule TimekeepWeb.ChangesetJSON do
  @doc """
  Renders changeset errors.
  """
  def error(%{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{
      code: "BAD_REQUEST",
      message: "Something went wrong while processing your request data",
      details: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    }
  end

  defp translate_error({msg, opts}) do
    # You can make use of gettext to translate error messages by
    # uncommenting and adjusting the following code:

    # if count = opts[:count] do
    #   Gettext.dngettext(TimekeepWeb.Gettext, "errors", msg, msg, count, opts)
    # else
    #   Gettext.dgettext(TimekeepWeb.Gettext, "errors", msg, opts)
    # end

    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end
end
