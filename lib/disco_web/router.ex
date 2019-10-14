defmodule DiscoWeb.Router do
  use DiscoWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(DiscoWeb.Context)
  end

  scope "/" do
    pipe_through(:api)

    forward("/api", Absinthe.Plug, schema: DiscoWeb.Schema)

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: DiscoWeb.Schema,
      socket: DiscoWeb.UserSocket,
      interface: :playground
    )
  end

  scope "/verify/:token" do
    pipe_through(:browser)

    get("/", DiscoWeb.RegisterVerification, :index)
  end
end
