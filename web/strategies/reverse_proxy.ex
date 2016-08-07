defmodule ReverseProxy.ForwardRequest do
  import Plug.Conn
  alias ReverseProxy.Router

  @client Application.get_env(:reverse_proxy, :forward_request)[:client]

  def init([]), do: false
  def init(opts), do: opts

  def call(conn, _opts) do
    routes = Router.__routes__
    conn
    |> match_route(routes)
    |> handle_request()
    |> send_response()
  end

  def match_route(%Plug.Conn{request_path: request_path} = conn, routes) do
    case Enum.find(routes, fn r -> r.path == request_path end) do
      nil -> {:err, conn}
      _ -> {:ok, conn}
    end
  end

  def handle_request({:err, %Plug.Conn{method: method} = conn}) do
    {:ok, []} = @client.start
    forward_request(method, conn)
  end
  def handle_request({:ok, conn}), do: conn

  def send_response({:ok, conn, res}) do
    conn = %{conn | resp_headers: res.headers}
    send_resp(conn, res.status_code, res.body)
  end
  def send_response(_) do
    raise "Could not forward request"
  end

  defp forward_request("GET", %Plug.Conn{params: params, req_headers: req_headers, request_path: url} = conn) do
    res = @client.get!(url, req_headers, [params: Map.to_list(params)])
    {:ok, conn, res}
  end
  defp forward_request("PUT", %Plug.Conn{}) do
    raise "Not implemented"
  end
  defp forward_request("PATCH", %Plug.Conn{}) do
    raise "Not implemented"
  end
  defp forward_request("POST", %Plug.Conn{}) do
    raise "Not implemented"
  end
  defp forward_request("OPTIONS", %Plug.Conn{}) do
    raise "Not implemented"
  end
  defp forward_request("DELETE", %Plug.Conn{}) do
    raise "Not implemented"
  end
end
