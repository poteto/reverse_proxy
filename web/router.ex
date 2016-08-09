defmodule ReverseProxy.Router do
  use ReverseProxy.Web, :router
  use Terraform,
    terraformer: ReverseProxy.Terraformers.Giphy

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", ReverseProxy do
    pipe_through :api

    get "/foo", FooController, :index
    get "/bar", BarController, :index
    get "/baz", BazController, :index
  end
end
