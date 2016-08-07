# ReverseProxy

## What is this?

A proof of concept Plug that intercepts requests to missing routes, and forwards them along to somewhere else of your choosing. The main use-case for this is to incrementally replace an API with Phoenix.

## Why not wildcards?

I was unable to get this working using wildcard paths. For example, the `forward` macro rejects dynamic segments:

```elixir
forward "/*path", to: ReverseProxy.ForwardRequest
```

```
== Compilation error on file web/router.ex ==
** (ArgumentError) Dynamic segment `"/*path"` not allowed when forwarding. Use a static path instead.
    (phoenix) lib/phoenix/router/route.ex:172: Phoenix.Router.Route.forward_path_segments/3
    web/router.ex:14: (module)
    (stdlib) erl_eval.erl:670: :erl_eval.do_apply/6
    (elixir) lib/kernel/parallel_compiler.ex:116: anonymous fn/4 in Kernel.ParallelCompiler.spawn_compilers/1
```

## How it works

This first begins in the [endpoint](lib/reverse_proxy/endpoint.ex) - the `ForwardRequest` plug is inserted prior to the `conn` hitting the `Router`.

This [plug](web/strategies/forward_request.ex) checks the request's path to see if a route is already defined on the Router. If it does exist, the `conn` is simply passed through. If it doesn't, the plug will attempt to call the `client` module which is currently always a `HTTPoison.Base` wrapper around your actual API. The request is forwarded along to the right place, and if a response comes back it is simply passed back in the `conn`.

For example, start the app, then try to do a `GET` to `/api/{foo,bar,baz}` – they should work as normal. Then, try a `GET` to `/v1/gifs/search?q=funny+cat&api_key=dc6zaTOxFJmzC` – this should forward the request to Giphy's public API and respond accordingly with funny cats.

## How you would use it (API)

If there's interest and no other better solution, I will turn this into a Hex package. You would have to:

1. Create the HTTP client that wraps your API. This client should have a similar interface to HTTPoison (`get`, `post`, etc)
1. Add the `ForwardRequest` plug to your `Endpoint`, just before the `Router`, passing in the client as an option
1. Incrementally replace your API with Phoenix!
1. All of your API is now in Phoenix, remove the package and carry on

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
