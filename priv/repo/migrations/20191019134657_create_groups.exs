defmodule Disco.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add(:name, :string)
      add(:owner, :integer)
      add(:friendly_id, :string)

      timestamps()
    end
  end
end
