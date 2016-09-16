defmodule ReverseProxy.HealthcheckController do
  use ReverseProxy.Web, :controller

  def index(conn, _) do
    send_resp(conn, 200)
  end
end
