defmodule Disco.Repo.Migrations.CreateGroupParticipants do
  use Ecto.Migration

  def change do
    create table(:group_participants) do
      add(:group_id, references(:groups))
      add(:user_id, references(:users))
      add(:joined, :boolean, default: false)
    end

    create(unique_index(:group_participants, [:group_id, :user_id]))
  end
end
