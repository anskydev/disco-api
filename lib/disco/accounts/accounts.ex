defmodule Disco.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Disco.Repo
  alias Comeonin.Ecto.Password

  alias Disco.Accounts.User

  def authenticate(email, password) do
    user = Repo.get_by(User, email: email)

    with %{password: digest} <- user,
         true <- Password.valid?(password, digest) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  def register(user_data) do
    case User.register_changeset(%User{}, user_data) do
      {:ok, user} ->
        {:ok, user}

      {:error, _} ->
        {:error, "email is already in use."}
    end
  end

  def send_verification_email(user_name, verification_url) do
    IO.inspect(user_name: user_name, verification_url: verification_url)
  end

  def verify_account(user_id) do
    user = Disco.Accounts.lookup(user_id)

    unless user.verified == true do
      User.update_changeset(user_id, %{verified: true})
    end
  end

  def lookup(id) do
    Repo.get_by(User, id: id)
  end
end
