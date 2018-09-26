defmodule Benzinpreise.PageTitle do
  alias Benzinpreise.{ PageView }

  @suffix "Benzinpreise"

  def page_title(assigns), do: assigns |> get |> put_suffix

  defp put_suffix(nil), do: @suffix
  defp put_suffix(title), do: title <> " - " <> @suffix

  defp get(%{ title: title }), do: title
  defp get(_), do: nil
end