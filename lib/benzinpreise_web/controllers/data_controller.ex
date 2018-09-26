defmodule BenzinpreiseWeb.DataController do
  use BenzinpreiseWeb, :controller

  alias Benzinpreise.Utils
  import Benzinpreise.HistoricData, only: [find_in_range: 2 ]

  @default_id "2330ac9d-9376-4fd9-90aa-e5f9934bcf3d"

  def day(conn, _params) do

    data = ~D[2018-08-03]
    |> Utils.calc_date_range(0)
    |> find_in_range( @default_id )

    conn |> json( data )

  end

end
