defmodule ReverseProxy.Mixfile do
  use Mix.Project

  def project do
    [app: :reverse_proxy,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {ReverseProxy, []},
     extra_applications: [:logger]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, ">= 1.2.0 and < 2.0.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:httpoison, "~> 0.11"},
     {:gettext, "~> 0.13"},
     {:cowboy, "~> 1.1"},
     {:terraform, "~> 1.0.1"}]
  end
end
