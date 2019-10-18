defmodule DiscoWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation

  object :user do
    field(:email, :string)
    field(:name, :string)
  end

  object :user_result do
    field(:user, :user)
    field(:errors, list_of(:string))
  end

  object :user_session_result do
    field(:user, :user)
    field(:token, :string)
    field(:error, :string)
  end

  object :customer do
    field(:user, :user)

    field :orders, list_of(:order) do
      resolve(fn customer, _, _ ->
        import Ecto.Query

        orders =
          Disco.Ordering.Order
          |> where(customer_id: ^customer.id)
          |> Disco.Repo.all()

        {:ok, orders}
      end)
    end
  end
end
