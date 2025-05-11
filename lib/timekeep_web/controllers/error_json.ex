defmodule TimekeepWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render("error.json", %{code: code, message: message} = assigns) do
    reponse = %{
      code: code,
      message: message
    }

    response =
      if assigns[:details], do: Map.put(reponse, :details, assigns[:details]), else: reponse

    response
  end
end
