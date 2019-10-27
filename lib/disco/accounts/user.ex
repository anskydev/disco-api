defmodule Disco.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:password, Comeonin.Ecto.Password)
    field(:verified, :boolean, default: false)
    many_to_many(:groups, Disco.Groups.Group, join_through: "groups_participants")

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_change(:email, &valid_email?/2)
    |> validate_length(:name, min: 3, max: 18)
    |> validate_length(:password, min: 5, max: 300)
    |> unique_constraint(:email)
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
