defmodule BackendWeb.DefaultController do
  use BackendWeb, :controller

  def index(conn, _params) do
    text conn, "BackendWeb!"
  end
end
