defmodule Disco.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field(:name, :string)
    field(:owner, :integer)
    field(:friendly_id, :string)

    many_to_many(
      :participants,
      Disco.Accounts.User,
      join_through: "groups_participants",
      on_delete: :delete_all
    )

    timestamps()
  end

  @doc false
  def changeset(group, %{friendly_id: friendly_id} = attrs) do
    group
    |> cast(attrs, [:name, :owner, :friendly_id])
    |> validate_required([:name, :owner, :friendly_id])
    |> unique_constraint(:friendly_id)
    |> validate_length(:friendly_id, min: 4, max: 18)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :owner])
    |> validate_required([:name, :owner])
    |> put_change(:friendly_id, Disco.URLGenerator.generate())
  end
end
