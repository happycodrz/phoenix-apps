defmodule Updater.ReadmeUpdater do
  alias Updater.{Parallel, DataParser}
  def run() do
    DataParser.parse |> Enum.map(fn({a, _, _})-> a end) |> run
  end

  def run(urls) do
    urls |> Parallel.run(20, fn(url)-> Updater.Crawler.stats(url) end)
  end
end
