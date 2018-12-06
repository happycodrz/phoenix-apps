defmodule UmbrellaFinder do
  @moduledoc """
  greps the `src` folder for possible umbrella projects
  """
  alias UmbrellaFinder.Cache
  def run do
    Cache.start()
    all_mix_exs()
    |> Enum.reject(fn x -> String.contains?(x, "deps") end)
    |> Enum.filter(fn x -> String.contains?(x, "/apps") end)
    |> Enum.map(fn x -> x |> String.split("/apps/") |> Enum.at(0) end)
    |> Enum.uniq()
    |> Enum.map(fn(x)-> String.replace(x, srcfolder() <> "/", "") end)
  end

  def all_mix_exs do
    Cache.fetch("all_mix_exs", fn ->
      Path.wildcard(pattern())
    end)
  end

  defp srcfolder do
    Path.join([__DIR__, "..", "..", "src"]) |> Path.expand()
  end

  defp pattern do
    [srcfolder(), "**", "mix.exs"] |> Enum.join("/")
  end
end

defmodule UmbrellaFinder.Cache do
  @moduledoc """
  little wrapper around ETS
  """
  @table __MODULE__

  def start do
    try do
      :ets.new(@table, [:named_table, read_concurrency: true])
    rescue
      _ -> :ok
    end
  end

  def fetch(key, fun) do
    case lookup(key) do
      {:hit, value} ->
        value

      :miss ->
        value = fun.()
        put(key, value)
        value
    end
  end

  defp lookup(key) do
    case :ets.lookup(@table, key) do
      [{^key, value}] ->
        {:hit, value}

      _ ->
        :miss
    end
  end

  defp put(key, value) do
    :ets.insert(@table, {key, value})
  end
end
