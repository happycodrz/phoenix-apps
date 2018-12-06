defmodule Updater do
  alias Updater.{Parallel, DataParser, Git}

  def run do
    data = DataParser.parse()
    cwd = System.cwd()

    try do
      File.cd("../")
      data |> Parallel.run(20, fn {url, _tags, _description} -> update(url) end)
    after
      File.cd(cwd)
    end
  end

  def update(url) do
    Git.download(url)
  end
end
