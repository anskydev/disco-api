defmodule DiscoWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation

  object :session do
    field(:token, :string)
    field(:user, :user)
  end

  enum :role do
    value(:employee)
    value(:customer)
  end

  interface :user do
    field(:email, :string)
    field(:name, :string)

    resolve_type(fn
      %{role: "employee"}, _ -> :employee
      %{role: "customer"}, _ -> :customer
    end)
  end

  object :employee do
    interface(:user)
    field(:email, :string)
    field(:name, :string)
  end

  object :customer do
    # Other fields
    interface(:user)
    field(:email, :string)
    field(:name, :string)

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
