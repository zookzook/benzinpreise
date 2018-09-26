defmodule BenzinpreiseWeb.PageController do
  use BenzinpreiseWeb, :controller

  def index(conn, _params) do

    conn
    |> assign(:title, "Benzinpreise")
    |> assign(:header, "Benzinpreise - Übersicht")
    |> render( "index.html" )

  end

end
