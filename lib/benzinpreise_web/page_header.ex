defmodule Benzinpreise.PageHeader do
  alias Benzinpreise.{ PageView }

  @suffix "Benzinpreise"

  def page_header(assigns), do: assigns |> get |> put_suffix

  defp put_suffix(nil), do: @suffix
  defp put_suffix(title), do: title

  defp get(%{ header: header }), do: header
  defp get(_), do: nil
end