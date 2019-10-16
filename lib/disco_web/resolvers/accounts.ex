defmodule DiscoWeb.Resolvers.Accounts do
  alias Disco.{Accounts, Accounts.User, Mailer}
  alias DiscoWeb.{Router.Helpers, Authentication}

  def login(_, %{email: email, password: password}, _) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        token = Authentication.sign(%{id: user.id})
        {:ok, %{token: token, user: user}}

      _ ->
        {:error, "incorrect email or password"}
    end
  end

  def register(_, args, _) do
    case Accounts.register(args) do
      {:ok, %User{name: name, email: email, id: id}} ->
        token = Authentication.sign(%{id: id}, :register)
        verification_url = Helpers.register_verification_url(DiscoWeb.Endpoint, :index, token)

        Mailer.send_verification_email(email, name, verification_url)
        {:ok, %{name: name, email: email}}

      {:error, message} ->
        {:error, message}
    end
  end

  def me(_, _, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def me(_, _, _) do
    {:ok, nil}
  end
end
