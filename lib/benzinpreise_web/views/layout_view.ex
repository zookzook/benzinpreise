defmodule BenzinpreiseWeb.LayoutView do
  use BenzinpreiseWeb, :view

  alias Benzinpreise.{ PageTitle, PageHeader }

  def title("header.html", _assigns) do
    "Benzinpreise - Übersicht"
  end

end
