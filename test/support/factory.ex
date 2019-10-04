defmodule Factory do
  def create_user(role) do
    int = :erlang.unique_integer([:positive, :monotonic])

    params = %{
      name: "Person #{int}",
      email: "fake-#{int}@example.com",
      password: "super-secret",
      role: role
    }

    %Disco.Accounts.User{}
    |> Disco.Accounts.User.changeset(params)
    |> Disco.Repo.insert!()
  end
end
