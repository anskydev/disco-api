defmodule DiscoWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by
  subscription tests
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use DiscoWeb.ChannelCase

      use Absinthe.Phoenix.SubscriptionTest,
        schema: DiscoWeb.Schema

      setup do
        Disco.Seeds.run()

        {:ok, socket} = Phoenix.ChannelTest.connect(DiscoWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket}
      end

      import unquote(__MODULE__), only: [menu_item: 1]
    end
  end

  # handy function for grabbing a fixture
  def menu_item(name) do
    Disco.Repo.get_by!(Disco.Menu.Item, name: name)
  end
end
