defmodule Updater.Querier do
  def for_tag(tag) do
    data()
    |> Enum.filter(fn {_url, tags, _desc} ->
      Enum.any?(tags, fn x -> x |> String.contains?(tag) end)
    end)
  end

  def tags do
    data()
    |> Enum.reduce([], fn {_url, tags, _desc}, acc -> (acc ++ tags) |> Enum.uniq() end)
    |> Enum.sort()
  end

  def data do
    Updater.DataParser.parse()
  end
end
