defmodule DiscoWeb.Schema do
  use Absinthe.Schema

  alias DiscoWeb.Resolvers
  alias DiscoWeb.Schema.Middleware
  alias Crudry.Middlewares.TranslateErrors

  def middleware(middleware, field, object) do
    middleware
    |> apply(:errors, field, object)
    |> apply(:debug, field, object)
  end

  defp apply(middleware, :errors, _field, %{identifier: :mutation}) do
    middleware ++ [TranslateErrors]
  end

  defp apply(middleware, :debug, _field, _object) do
    if System.get_env("DEBUG") do
      [{Middleware.Debug, :start}] ++ middleware
    else
      middleware
    end
  end

  defp apply(middleware, _, _, _) do
    middleware
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def dataloader() do
    alias Disco.Menu

    Dataloader.new()
    |> Dataloader.add_source(Menu, Menu.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end

  import_types(__MODULE__.MenuTypes)
  import_types(__MODULE__.OrderingTypes)
  import_types(__MODULE__.AccountsTypes)
  import_types(__MODULE__.GroupsTypes)

  query do
    field :me, :user do
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.Accounts.me/3)
    end

    field :menu_items, list_of(:menu_item) do
      arg(:filter, :menu_item_filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.menu_items/3)
    end

    field :verify_password, :boolean do
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.verify_password/3)
    end
  end

  mutation do
    field :login, :user_session_result do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.login/3)

      middleware(fn res, _ ->
        with %{value: %{user: user}} <- res do
          %{res | context: Map.put(res.context, :current_user, user)}
        end
      end)
    end

    field :register, :user_result do
      arg(:name, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.register/3)
    end

    field :update_user, :user_result do
      arg(:name, :string)
      arg(:email, :string)
      arg(:password, :string)
      resolve(&Resolvers.Accounts.update/3)
    end

    field :logout, :boolean do
      resolve(fn _, _, _ -> {:ok, true} end)

      middleware(fn res, _ ->
        %{res | context: Map.put(res.context, :current_user, %{})}
      end)
    end

    field :create_group, :group_result do
      arg(:name, non_null(:string))
      arg(:friendly_id, :string)
      resolve(&Resolvers.Groups.create/3)
    end
  end

  subscription do
    field :update_order, :order do
      arg(:id, non_null(:id))

      config(fn args, _info ->
        {:ok, topic: args.id}
      end)

      trigger([:ready_order, :complete_order],
        topic: fn
          %{order: order} -> [order.id]
          _ -> []
        end
      )

      resolve(fn %{order: order}, _, _ ->
        {:ok, order}
      end)
    end

    field :new_order, :order do
      config(fn _args, %{context: context} ->
        case context[:current_user] do
          %{role: "customer", id: id} ->
            {:ok, topic: id}

          %{role: "employee"} ->
            {:ok, topic: "*"}

          _ ->
            {:error, "unauthorized"}
        end
      end)
    end
  end

  @desc "An error encountered trying to persist input"
  object :input_error do
    field(:key, non_null(:string))
    field(:message, non_null(:string))
  end

  scalar :date do
    parse(fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
           {:ok, date} <- Date.from_iso8601(value) do
        {:ok, date}
      else
        _ -> :error
      end
    end)

    serialize(fn date ->
      Date.to_iso8601(date)
    end)
  end

  scalar :decimal do
    parse(fn
      %{value: value}, _ ->
        Decimal.parse(value)

      _, _ ->
        :error
    end)

    serialize(&to_string/1)
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end
end
