defmodule Benzinpreise.HistoricData do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}
  @max_value 10000 ## 1209 = 1.209
  @min %{date: Date.utc_today(), e10: @max_value, e5: @max_value, diesel: @max_value}

  schema "gas_station_information_history" do
    field(:stid, :binary_id)      ## uuid in Postgres
    field(:date, :utc_datetime)
    field(:e10, :integer)
    field(:e5, :integer)
    field(:diesel, :integer)
  end

  def find_in_range( { from, to }, stid ) do

    import Ecto.Query

    Benzinpreise.Repo.all(
      from(d in Benzinpreise.HistoricData,
        where: d.stid == ^stid,   ## wird automatisch in binary umgewandelt, alternativ type( ^stid, Ecto.UUID ), muss aber als String übergeben werden
        where: d.date >= ^from,
        where: d.date <= ^to,
        order_by: d.date,
        select: %{date: d.date, e10: d.e10, e5: d.e5, diesel: d.diesel}
      )
    )
  end

  def find_from_day( from, stid, offset ) do

    {:ok, fromDate} = NaiveDateTime.new(from, ~T[00:00:00])
    {:ok, toDate}   = NaiveDateTime.new(Date.add(from, offset), ~T[23:59:59])
    { fromDate, toDate } |> find_in_range( stid )

  end

  def find_from_month( from, stid ) do

    offset          = Date.days_in_month(from) - 1
    {:ok, fromDate} = NaiveDateTime.new(from, ~T[00:00:00])
    {:ok, toDate}   = NaiveDateTime.new(Date.add(from, offset), ~T[23:59:59])
    { fromDate, toDate } |> find_in_range( stid )

  end

  def min_by_kind( list, kind ) do
    list
    |> List.foldl( @min, fn (l,r) -> if l[kind] < r[kind], do: l, else: r end )
  end

  def chunk_by_week( list ) do
    list
    |> Enum.chunk_by( fn record -> Date.day_of_week( record.date ) == 1 end)
  end

  def chunk_by_day(list) do
    list
    |> Enum.chunk_by( fn record -> Date.day_of_week( record.date ) end)
  end

end
