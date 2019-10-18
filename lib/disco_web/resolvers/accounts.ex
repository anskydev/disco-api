defmodule DiscoWeb.Resolvers.Accounts do
  alias Disco.{Accounts, Accounts.User, Mailer}
  alias DiscoWeb.{Router.Helpers, Authentication}

  def login(_, %{email: email, password: password}, _) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        token = Authentication.sign(%{id: user.id})
        {:ok, %{token: token, user: user}}

      :error ->
        {:error, "incorrect email or password"}
    end
  end

  def register(_, args, _) do
    with {:ok, %User{name: name, email: email, id: id}} <- Accounts.create_user(args) do
      token = Authentication.sign(%{id: id}, :register)
      verification_url = Helpers.register_verification_url(DiscoWeb.Endpoint, :index, token)

      Mailer.send_verification_email(email, name, verification_url)
      {:ok, %{user: %{name: name, email: email}}}
    end
  end

  def update(_, args, %{context: %{current_user: current_user}}) do
    case Accounts.update_user(current_user, args) do
      {:ok, user} -> {:ok, %{user: %{name: user.name, email: user.email}}}
    end
  end

  def me(_, _, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def me(_, _, _) do
    {:ok, nil}
  end

  def verify_password(_, %{password: password}, %{context: %{current_user: current_user}}) do
    case Comeonin.Ecto.Password.valid?(password, current_user.password) do
      true -> {:ok, true}
      _ -> {:ok, false}
    end
  end
end
