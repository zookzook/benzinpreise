defmodule Benzinpreise.Utils do
  @moduledoc false

  def is_stid(stid) do
    case Ecto.UUID.dump(stid) do
      {:ok, _} -> true
      _        -> false
    end
  end

  def parse_date(d) do
    case Date.from_iso8601(d) do
      {:ok, d} -> d
      _        -> Date.utc_today()
    end
  end

  def calc_date_range( from, offset ) do
    {:ok, fromDate} = NaiveDateTime.new(from, ~T[00:00:00])
    {:ok, toDate}   = NaiveDateTime.new(Date.add(from, offset), ~T[23:59:59])
    { fromDate, toDate }
  end

end
