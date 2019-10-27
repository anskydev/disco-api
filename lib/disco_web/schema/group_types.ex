defmodule DiscoWeb.Schema.GroupsTypes do
  use Absinthe.Schema.Notation

  object :group do
    field(:name, :string)
    field(:owner, :integer)
  end

  object :group_result do
    field(:name, :string)
    field(:url, :string)
  end
end
