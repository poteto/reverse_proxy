defmodule ReverseProxy.Terraformers.Giphy do
  alias ReverseProxy.Clients.Giphy
  import Plug.Conn
  import ReverseProxy.Terraform, only: [send_response: 1]

  def get(path, %Plug.Conn{params: params, req_headers: req_headers} = conn) do
    res = Giphy.get!(path, req_headers, [params: Map.to_list(params)])
    send_response({:ok, conn, res})
  end

  def put(_, _),      do: raise "Not implemented yet"
  def patch(_, _),    do: raise "Not implemented yet"
  def post(_, _),     do: raise "Not implemented yet"
  def options(_, _),  do: raise "Not implemented yet"
  def delete(_, _),   do: raise "Not implemented yet"
  def head(_, _),     do: raise "Not implemented yet"
  def trace(_, _),    do: raise "Not implemented yet"
  def connect(_, _),  do: raise "Not implemented yet"
end
