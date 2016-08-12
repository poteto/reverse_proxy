defmodule ReverseProxy.Terraformers.Giphy do
  alias ReverseProxy.Clients.Giphy
  use Plug.Router

  plug :match
  plug :dispatch

  # match specific path
  get "/v1/hello-world", do: send_resp(conn, 200, "Hello world")

  # catch all `get`s
  get _ do
    %{method: "GET", request_path: request_path, params: params, req_headers: req_headers} = conn
    res = Giphy.get!(request_path, req_headers, [params: Map.to_list(params)])
    send_response({:ok, conn, res})
  end

  match _, do: raise "Not implemented yet"

  defp send_response({:ok, conn, %{headers: headers, status_code: status_code, body: body}}) do
    conn = %{conn | resp_headers: headers}
    send_resp(conn, status_code, body)
  end
end
