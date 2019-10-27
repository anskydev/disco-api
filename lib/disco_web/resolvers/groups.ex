defmodule DiscoWeb.Resolvers.Groups do
  alias Disco.{Groups, Repo, GroupParticipants}

  def create(_, args, %{context: %{current_user: current_user}}) do
    args_with_owner = Map.merge(args, %{owner: current_user.id})

    case Groups.create_group(args_with_owner) do
      {:ok, group} ->
        group
        |> Repo.preload(:participants)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:participants, [current_user])
        |> Repo.update!()

        owner_group_participant =
          Repo.get_by!(GroupParticipants, group_id: group.id, user_id: current_user.id)

        # owner_joined =
        #  GroupParticipants.update_group_participants(owner_group_participant, %{joined: true})

        IO.inspect(owner_group_participant, label: "owner_group_participant")

        {:ok, %{name: group.name, url: group.friendly_id}}

      _ ->
        {:error, "oops"}
    end
  end
end
