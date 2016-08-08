# ReverseProxy

## What is this?

A proof of concept Plug that intercepts requests to missing routes, and forwards them along to somewhere else of your choosing. The main use-case for this is to incrementally replace an API with Phoenix.

This is currently being implemented as a Hex package called [Terraform](https://github.com/poteto/terraform). With `Terraform`, you'll be able to incrementally transform your API into one powered by Phoenix.

## Demo

Install dependencies, start the app, then try to do a `GET` to `/v1/{foo,bar,baz}` – they should work as normal. Then, try a `GET` to `/v1/gifs/search?q=funny+cat&api_key=dc6zaTOxFJmzC` – this should forward the request to Giphy's public API and respond accordingly with funny cats.

You can also try a `GET` to `/v1/hello-world`, which is an example of directly matching a request by path.

## Example usage

When `Terraform` is available for download, you'll be able to use it like this:

First, add it to `web/router.ex`:

```elixir
defmodule ReverseProxy.Router do
  use Terraform.Discovery,
    terraformer: MyApp.Terraformers.Foo

  # ...
end
```

Then, define a new `Terraformer`:

```elixir
defmodule MyApp.Terraformers.Foo do
  # example client made with HTTPoison
  alias ReverseProxy.Clients.Foo
  import Plug.Conn
  import Terraform, only: [send_response: 1]

  # match specific path
  def get("/v1/hello-world", conn) do
    send_resp(conn, 200, "Hello world")
  end
  # catch all `get`s
  def get(path, %Plug.Conn{params: params, req_headers: req_headers} = conn) do
    res = Foo.get!(path, req_headers, [params: Map.to_list(params)])
    send_response({:ok, conn, res})
  end

  def put(_, _),      do: raise "Not implemented yet"
  def patch(_, _),    do: raise "Not implemented yet"
  def post(_, _),     do: raise "Not implemented yet"
  def options(_, _),  do: raise "Not implemented yet"
  def delete(_, _),   do: raise "Not implemented yet"
  def head(_, _),     do: raise "Not implemented yet"
  def trace(_, _),    do: raise "Not implemented yet"
  def connect(_, _),  do: raise "Not implemented yet"
end
```

## Setup

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
