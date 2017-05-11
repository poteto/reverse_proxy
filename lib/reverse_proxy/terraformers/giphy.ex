defmodule ReverseProxy.Terraformers.Giphy do
  use Plug.Router
  require Logger
  alias ReverseProxy.Clients.Giphy

  @host Application.get_env(:reverse_proxy, :giphy)[:host]

  plug :match
  plug :dispatch

  # match specific path
  get "/v1/hello-world", do: send_resp(conn, 200, "Hello world")

  # catch all `get`s
  get _ do
    %{method: "GET", request_path: request_path, params: params, req_headers: req_headers} = conn
    Logger.debug """
    Processing by #{__MODULE__}
      Path: #{@host <> request_path}
      Parameters: #{inspect params}
      Headers: #{inspect req_headers}
    """
    res = Giphy.get!(request_path, req_headers, [params: Map.to_list(params)])
    send_response({:ok, conn, res})
  end

  match _, do: raise "Not implemented yet"

  defp send_response({:ok, conn, %{headers: headers, status_code: status_code, body: body}}) do
    conn = %{conn | resp_headers: headers}
    send_resp(conn, status_code, body)
  end
end
