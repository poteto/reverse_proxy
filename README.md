# ReverseProxy

## What is this?

A proof of concept Plug that intercepts requests to missing routes, and forwards them along to somewhere else of your choosing. The main use-case for this is to incrementally replace an API with Phoenix.

## How it works

This first begins in the [endpoint](lib/reverse_proxy/endpoint.ex) - the `ForwardRequest` plug is inserted prior to the `conn` hitting the `Router`.

This [plug](web/strategies/forward_request.ex) checks the request's path to see if a route is already defined on the Router. If it does exist, the `conn` is simply passed through. If it doesn't, the plug will attempt to call the `client` module defined on [`dev.exs`](config/dev.exs) which is currently always a `HTTPoison.Base` wrapper around your actual API. The request is forwarded along to the right place, and if a response comes back it is simply passed back in the `conn`.

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
