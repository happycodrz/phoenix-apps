defmodule Updater.DataParser do
  def parse do
    parse("../data/withdata.txt")
  end

  def parse(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [url, tags_string] = line |> String.split(" [")
    tags = tags_string |> String.replace("]", "") |> String.replace(" ", "") |> String.split(",")
    {url, tags}
  end
end
