defmodule Updater.Crawler do
  alias Updater.Github
  def stats(repo) do
    {:ok, response} = Github.get(repo)

    %{
      description: description(response.body),
      lastcommit: lastcommit(response.body),
      commitscount: commitscount(response.body),
      stars: stars(response.body)
    }
  end

  def description(body) do
    body
    |> Floki.find("meta")
    |> Enum.find(&is_description/1)
    |> extract_desc
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

  defp is_description(
         {
           "meta",
           [
             {"name", "description"},
             {"content", "GitHub is " <> _}
           ],
           []
         }
       ),
       do: false

  defp is_description({"meta", [{"name", "description"}, {"content", _proj_with_desc}], []}) do
    true
  end

  defp is_description(_), do: false

  defp extract_desc({"meta", [{"name", "description"}, {"content", proj_with_desc}], []}) do
    proj_with_desc |> String.split(" - ") |> Enum.at(1)
  end

  defp extract_desc(nil) do
    "----"
  end


  defp commitscount(body) do
    body
    |> Floki.find(".numbers-summary .commits .num")
    |> Floki.text
    |> cleannumber_from_text
  end

  defp stars(body) do
    body
    |> Floki.find(".social-count")
    |> Enum.at(1)
    |> Floki.text
    |> cleannumber_from_text
  end

  defp cleannumber_from_text(text) do
    text
    |> String.replace(",", "")
    |> String.trim
    |> String.to_integer

  end
end
