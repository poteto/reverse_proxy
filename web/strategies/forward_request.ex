defmodule ReverseProxy.ForwardRequest do
  import Plug.Conn

  def init([]), do: false
  def init(opts), do: opts

  def call(conn, client: client, router: router) do
    routes = router.__routes__
    conn
    |> match_route(routes)
    |> handle_request(client)
    |> send_response()
  end

  def match_route(%Plug.Conn{request_path: request_path} = conn, routes) do
    case Enum.find(routes, fn r -> r.path == request_path end) do
      nil -> {:err, conn}
      _ -> {:ok, conn}
    end
  end

  def handle_request({:err, %Plug.Conn{method: method} = conn}, client) do
    {:ok, []} = client.start
    forward_request(method, conn, client)
  end
  def handle_request({:ok, conn}, _client), do: conn

  def send_response({:ok, conn, %{headers: headers, status_code: status_code, body: body}}) do
    conn = %{conn | resp_headers: headers}
    send_resp(conn, status_code, body)
  end
  def send_response(%Plug.Conn{} = conn), do: conn
  def send_response(_) do
    raise "Could not forward request"
  end

  defp forward_request("GET", %Plug.Conn{params: params, req_headers: req_headers, request_path: url} = conn, client) do
    res = client.get!(url, req_headers, [params: Map.to_list(params)])
    {:ok, conn, res}
  end
  defp forward_request("PUT", %Plug.Conn{}, _client) do
    raise "Not implemented"
  end
  defp forward_request("PATCH", %Plug.Conn{}, _client) do
    raise "Not implemented"
  end
  defp forward_request("POST", %Plug.Conn{}, _client) do
    raise "Not implemented"
  end
  defp forward_request("OPTIONS", %Plug.Conn{}, _client) do
    raise "Not implemented"
  end
  defp forward_request("DELETE", %Plug.Conn{}, _client) do
    raise "Not implemented"
  end
end
