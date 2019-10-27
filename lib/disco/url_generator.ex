defmodule Disco.URLGenerator do
  alias Disco.Groups.Group
  alias Disco.Repo

  def generate() do
    adjective =
      Randomizer.words!(1, dictionary: 'priv/static/dictionaries/adjectives')
      |> String.capitalize()

    animal =
      Randomizer.words!(1, dictionary: 'priv/static/dictionaries/animals')
      |> String.capitalize()

    number = Enum.random(1..99) |> Integer.to_string()

    url = "#{adjective}#{animal}#{number}"

    case Repo.get_by(Group, friendly_id: url) do
      {:ok, _} -> Disco.URLGenerator.generate()
      _ -> url
    end
  end
end
