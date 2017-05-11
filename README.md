# ReverseProxy

## What is this?

[Terraform](https://github.com/poteto/terraform) is a simple Plug that intercepts requests to missing routes, and forwards them along to somewhere else of your choosing. The main use-case for this is to incrementally replace an API with Phoenix.

## Demo

```
mix do deps.get, deps.compile
iex -S mix phoenix.server
```

Try to do a `GET` to `localhost:4000/v1/{foo,bar,baz}` – they should work as normal.

Then, try a `GET` to `localhost:4000/v1/gifs/search?q=funny+cat&api_key=dc6zaTOxFJmzC` – this should forward the request to Giphy's public API and respond accordingly with funny cats.

You can also try a `GET` to `localhost:4000/v1/hello-world`, which is an example of directly matching a request by path.

![](https://i.imgur.com/nC4RhB3.png)
![](https://i.imgur.com/tivzp13.png)

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
