defmodule ReverseProxy.Terraformers.Giphy do
  alias ReverseProxy.Clients.Giphy
  import Plug.Conn, only: [send_resp: 3]

  def init(opts), do: opts

  # match specific path
  def call(%{method: "GET", request_path: "/v1/hello-world"} = conn, _) do
    send_resp(conn, 200, "Hello world")
  end
  # catch all `get`s
  def call(%{method: "GET", request_path: request_path, params: params, req_headers: req_headers} = conn, _) do
    res = Giphy.get!(request_path, req_headers, [params: Map.to_list(params)])
    send_response({:ok, conn, res})
  end

  def call(%{method: "PUT"}, _),      do: raise "Not implemented yet"
  def call(%{method: "PATCH"}, _),    do: raise "Not implemented yet"
  def call(%{method: "POST"}, _),     do: raise "Not implemented yet"
  def call(%{method: "OPTIONS"}, _),  do: raise "Not implemented yet"
  def call(%{method: "DELETE"}, _),   do: raise "Not implemented yet"
  def call(%{method: "HEAD"}, _),     do: raise "Not implemented yet"
  def call(%{method: "TRACE"}, _),    do: raise "Not implemented yet"
  def call(%{method: "CONNECT"}, _),  do: raise "Not implemented yet"

  defp send_response({:ok, conn, %{headers: headers, status_code: status_code, body: body}}) do
    conn = %{conn | resp_headers: headers}
    send_resp(conn, status_code, body)
  end
end
