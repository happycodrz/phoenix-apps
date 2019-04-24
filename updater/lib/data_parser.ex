defmodule Updater.DataParser do
  def parse do
    parse("../data/urls.txt")
  end

  def parse(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(fn x -> x == "" end)
    |> Enum.reject(fn x -> Regex.match?(~r/^\#/, x) end)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    cond do
      String.contains?(line, "[") -> parse_line_with_tags(line)
      true -> {line, [], ""}
    end
  end

  def parse_line_with_tags(line) do
    [url, tags_and_description] = line |> String.split(" [")

    [tags_string, description] = tags_and_description |> String.split("]", parts: 2)

    tags =
      tags_string
      |> String.replace("]", "")
      |> String.replace(" ", "")
      |> String.split(",")
      |> Enum.reject(fn x -> x == "" end)
      |> Enum.sort()

    description = description |> String.trim()
    url = url |> String.trim()
    {url, tags, description}
  end
end
