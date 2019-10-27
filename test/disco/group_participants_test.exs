defmodule Disco.GroupParticipantsTest do
  use Disco.DataCase

  alias Disco.Groups

  describe "group_participants" do
    alias Disco.Groups.GroupParticipants

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def group_participants_fixture(attrs \\ %{}) do
      {:ok, group_participants} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Groups.create_group_participants()

      group_participants
    end

    test "list_group_participants/0 returns all group_participants" do
      group_participants = group_participants_fixture()
      assert Groups.list_group_participants() == [group_participants]
    end

    test "get_group_participants!/1 returns the group_participants with given id" do
      group_participants = group_participants_fixture()
      assert Groups.get_group_participants!(group_participants.id) == group_participants
    end

    test "create_group_participants/1 with valid data creates a group_participants" do
      assert {:ok, %GroupParticipants{} = group_participants} =
               Groups.create_group_participants(@valid_attrs)
    end

    test "create_group_participants/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_group_participants(@invalid_attrs)
    end

    test "update_group_participants/2 with valid data updates the group_participants" do
      group_participants = group_participants_fixture()

      assert {:ok, %GroupParticipants{} = group_participants} =
               Groups.update_group_participants(group_participants, @update_attrs)
    end

    test "update_group_participants/2 with invalid data returns error changeset" do
      group_participants = group_participants_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Groups.update_group_participants(group_participants, @invalid_attrs)

      assert group_participants == Groups.get_group_participants!(group_participants.id)
    end

    test "delete_group_participants/1 deletes the group_participants" do
      group_participants = group_participants_fixture()
      assert {:ok, %GroupParticipants{}} = Groups.delete_group_participants(group_participants)

      assert_raise Ecto.NoResultsError, fn ->
        Groups.get_group_participants!(group_participants.id)
      end
    end

    test "change_group_participants/1 returns a group_participants changeset" do
      group_participants = group_participants_fixture()
      assert %Ecto.Changeset{} = Groups.change_group_participants(group_participants)
    end
  end
end
