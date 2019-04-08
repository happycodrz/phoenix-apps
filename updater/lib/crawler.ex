defmodule Updater.Crawler do
  alias Updater.Github

  def stats(repo) do
    cond do
      String.contains?(repo, "github.com") -> github_stats(repo)
      true -> generic_default_stats(repo)
    end
  end

  def github_stats(repo) do
    IO.puts "getting #{repo}"

    with {:ok, response} <- Github.get(repo) do
      body =
        cond do
          response.status == 404 ->
            IO.puts "REPO not found! #{repo}"
            raise "FUCK"
            ""

          response.status == 301 ->
            IO.puts("**** MOVED #{repo}")
            raise ""

          is_binary(response.body) ->
            response.body |> Floki.parse()

          true ->
            response.body
        end

      %{
        repo: repo,
        description: description(body),
        lastcommit: lastcommit(body),
        commitscount: commitscount(body),
        stars: stars(body)
      }
    else
      a ->
        IO.puts "NOT FOUND #{repo}!"
        exit(1)
    end
  end

  def generic_default_stats(repo) do
    %{
      repo: repo,
      description: "---",
      lastcommit: "---",
      commitscount: 0,
      stars: 0
    }
  end

  def description(body) do
    body
    |> Floki.find("head title")
    |> Floki.text()
    |> String.split(": ", parts: 2)
    |> Enum.at(1)
  end

  def lastcommit(body) do
    if lastcommit_included?(body) do
      extract_included_lastcommit(body)
    else
      get_lastcommit_ajax(body)
    end
  end

  defp lastcommit_included?(body) do
    body |> Floki.find(".commit-loader") == []
  end

  defp extract_included_lastcommit(body) do
    body
    |> Floki.find(".commit-tease relative-time")
    |> Floki.attribute("datetime")
    |> Enum.at(0)
  end

  def get_lastcommit_ajax(body) do
    path =
      body
      |> Floki.find("include-fragment.commit-loader")
      |> Floki.attribute("src")
      |> Enum.at(0)

    # this feels dirty...
    url = "https://github.com/" <> path
    {:ok, doc} = Github.get(url)
    lastcommit(doc.body)
  end

  def commitscount(body) do
    body
    |> Floki.find(".numbers-summary .commits .num")
    |> Floki.text()
    |> cleannumber_from_text
  end

  def stars(body) do
    body
    |> Floki.find(".social-count")
    |> Enum.at(1)
    |> Floki.text()
    |> cleannumber_from_text
  end

  defp cleannumber_from_text(text) do
    text
    |> String.replace(",", "")
    |> String.trim()
    |> cleantoint
  end

  defp cleantoint(""), do: 0
  defp cleantoint(v) when is_binary(v), do: String.to_integer(v)
end
