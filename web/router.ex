defmodule ReverseProxy.Router do
  use ReverseProxy.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ReverseProxy do
    pipe_through :api

    get "/foo", FooController, :index
    get "/bar", BarController, :index
    get "/baz", BazController, :index
  end
end
