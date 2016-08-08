defmodule ReverseProxy.Terraformer.Discovery do
  defmacro __using__(opts) do
    quote location: :keep do
      Module.register_attribute __MODULE__, :terraformer, []
      @terraformer Keyword.get(unquote(opts), :terraformer)
      @before_compile ReverseProxy.Terraformer.Discovery
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote location: :keep do
      defoverridable [call: 2]
      require Logger

      def call(conn, opts) do
        try do
          super(conn, opts)
        catch
          _, %Phoenix.Router.NoRouteError{conn: %{method: method, request_path: request_path} = conn} ->
            verb =
              method
              |> String.downcase()
              |> String.to_atom()

            Logger.debug("Forwarding request to #{@terraformer}.#{verb}/2")
            apply(@terraformer, verb, [request_path, conn])
        end
      end
    end
  end
end
