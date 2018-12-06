defmodule Updater.ReadmeUpdater do
  alias Updater.{Parallel, DataParser}

  def run() do
    DataParser.parse() |> Enum.map(fn {a, _, _} -> a end) |> run
  end

  def run(urls) do
    stats_collection =
      urls
      |> Parallel.run(20, fn url -> Updater.Crawler.stats(url) end)
      |> Enum.map(fn {_url, stats} -> stats end)

    Updater.ReadmeHandler.replace_activity!(stats_collection)
    Updater.ReadmeHandler.replace_projects!(stats_collection)
    Updater.ReadmeHandler.replace_popularity!(stats_collection)
    Updater.ReadmeHandler.replace_commitcount!(stats_collection)
  end
end
