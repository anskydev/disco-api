defmodule Disco.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Disco.Accounts.User
  alias Disco.Repo

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:password, Comeonin.Ecto.Password)
    field(:verified, :boolean, default: false)

    timestamps()
  end

  def update_changeset(id, attrs) do
    user = Disco.Accounts.lookup(id)

    case attrs do
      %{name: _} ->
        user
        |> cast(attrs, [:name])
        |> validate_length(:name, min: 3, max: 18)
        |> change(attrs)
        |> Repo.update!()

      %{email: _} ->
        user
        |> cast(attrs, [:email])
        |> unique_constraint(:email)
        |> validate_change(:email, &valid_email?/2)
        |> change(attrs)
        |> Repo.update!()

      %{password: _} ->
        user
        |> cast(attrs, [:password])
        |> validate_length(:password, min: 5, max: 300)
        |> change(attrs)
        |> Repo.update!()

      %{verified: _} ->
        user
        |> cast(attrs, [:verified])
        |> change(attrs)
        |> Repo.update()

      _ ->
        {:error, "incorrect field(s) to update"}
    end
  end

  def register_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_change(:email, &valid_email?/2)
    |> validate_length(:name, min: 3, max: 18)
    |> validate_length(:password, min: 5, max: 300)
    |> unique_constraint(:email)
    |> Repo.insert()
  end

  defp valid_email?(_, email) do
    if Regex.match?(
         ~r/^(?!.*\.{2})(?!\.)[a-z0-9_.'-]*[a-z0-9_'-]@(?!_)(?:[a-z0-9_'-]+\.)+[a-z0-9_'-]{2,}$/,
         email
       ) do
      []
    else
      [email: "invalid email address format"]
    end
  end
end
