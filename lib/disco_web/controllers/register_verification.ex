defmodule DiscoWeb.RegisterVerification do
  use DiscoWeb, :controller

  def index(conn, %{"token" => token}) do
    status =
      case DiscoWeb.Authentication.verify(token) do
        {:ok, %{id: id}} ->
          Disco.Accounts.verify_account(id)
          "verified"

        {:error, :invalid} ->
          "invalid"

        {:error, :expired} ->
          "expired"
      end

    render(conn, "verify.html", status: status)
  end
end
