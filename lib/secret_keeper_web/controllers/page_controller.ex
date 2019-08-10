defmodule SecretKeeperWeb.PageController do
  use SecretKeeperWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
