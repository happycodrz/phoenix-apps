defmodule Updater.ReadmeHandler do


  def replace_umbrellas!(umbrellas) do
    content = File.read!("../Readme.md")
    new_content = replace_umbrellas(umbrellas, content)
    File.write!("../Readme.md", new_content)
  end
  def replace_projects!(projects) do
    content = File.read!("../Readme.md")
    new_content = replace_projects(projects, content)
    File.write!("../Readme.md", new_content)
  end

  def replace_activity!(projects) do
    content = File.read!("../Readme.md")
    new_content = replace_activity(projects, content)
    File.write!("../Readme.md", new_content)
  end

  def replace_commitcount!(projects) do
    content = File.read!("../Readme.md")
    new_content = replace_commitcount(projects, content)
    File.write!("../Readme.md", new_content)
  end

  def replace_popularity!(projects) do
    content = File.read!("../Readme.md")
    new_content = replace_popularity(projects, content)
    File.write!("../Readme.md", new_content)
  end

  def replace_umbrellas(umbrellas, content) do
    pattern = Regex.compile!("(?s)<!-- UMBRELLAS_LIST -->(.*)<!-- /UMBRELLAS_LIST -->")
    regexStart = "<!-- UMBRELLAS_LIST -->"
    regexEnd = "<!-- /UMBRELLAS_LIST -->"
    block = umbrellas |> Enum.map(fn(x)-> "- #{("https://" <> x) |> Updater.MarktdownFormatter.md_link()}" end) |> Enum.join("\n")
    block = regexStart <> "\n" <> block <> "\n" <> regexEnd
    Regex.replace(pattern, content, block)
  end

  def replace_projects(projects, content) do
    projects = Enum.sort_by(projects, fn x -> x.repo end)
    pattern = Regex.compile!("(?s)<!-- PROJECTS_LIST -->(.*)<!-- /PROJECTS_LIST -->")
    regexStart = "<!-- PROJECTS_LIST -->"
    regexEnd = "<!-- /PROJECTS_LIST -->"
    block = projects |> Enum.map(&Updater.MarktdownFormatter.project/1) |> Enum.join("\n")
    block = regexStart <> "\n" <> block <> "\n" <> regexEnd
    Regex.replace(pattern, content, block)
  end

  def replace_commitcount(projects, content) do
    projects = Enum.sort_by(projects, fn x -> x.commitscount end) |> Enum.reverse()
    pattern = Regex.compile!("(?s)<!-- COMMITCOUNT_LIST -->(.*)<!-- /COMMITCOUNT_LIST -->")
    regexStart = "<!-- COMMITCOUNT_LIST -->"
    regexEnd = "<!-- /COMMITCOUNT_LIST -->"
    block = projects |> Enum.map(&Updater.MarktdownFormatter.commitcount/1) |> Enum.join("\n")
    block = regexStart <> "\n" <> block <> "\n" <> regexEnd
    Regex.replace(pattern, content, block)
  end

  def replace_activity(projects, content) do
    projects = Enum.sort_by(projects, fn x -> x.lastcommit end) |> Enum.reverse()
    pattern = Regex.compile!("(?s)<!-- ACTIVITY_LIST -->(.*)<!-- /ACTIVITY_LIST -->")
    regexStart = "<!-- ACTIVITY_LIST -->"
    regexEnd = "<!-- /ACTIVITY_LIST -->"
    block = projects |> Enum.map(&Updater.MarktdownFormatter.activity/1) |> Enum.join("\n")
    block = regexStart <> "\n" <> block <> "\n" <> regexEnd
    Regex.replace(pattern, content, block)
  end

  def replace_popularity(projects, content) do
    projects = Enum.sort_by(projects, fn x -> x.stars end) |> Enum.reverse()
    pattern = Regex.compile!("(?s)<!-- POPULARITY_LIST -->(.*)<!-- /POPULARITY_LIST -->")
    regexStart = "<!-- POPULARITY_LIST -->"
    regexEnd = "<!-- /POPULARITY_LIST -->"
    block = projects |> Enum.map(&Updater.MarktdownFormatter.popularity/1) |> Enum.join("\n")
    block = regexStart <> "\n" <> block <> "\n" <> regexEnd
    Regex.replace(pattern, content, block)
  end
end

defmodule Updater.MarktdownFormatter do
  def activity(stats) do
    "- #{md_link(stats)} - #{stats.description} <br/> ( #{lastcommit_short(stats)} / #{
      stats.commitscount
    } commits / #{stats.stars} stars )"
  end

  def popularity(stats) do
    "- #{md_link(stats)} - #{stats.description} <br/> (#{stats.stars} stars / #{
      lastcommit_short(stats)
    } / #{stats.commitscount} commits )"
  end

  def commitcount(stats) do
    "- #{md_link(stats)} - #{stats.description} <br/> (#{stats.commitscount} commits / #{
      stats.stars
    } stars / #{lastcommit_short(stats)} )"
  end

  def project(stats) do
    "- #{md_link(stats)} - #{stats.description} <br/> ( #{lastcommit_short(stats)} / #{
      stats.commitscount
    } commits / #{stats.stars} stars )"
  end

  def md_link(%{repo: repo}) do
    "[#{short_url(repo)}](#{repo})"
  end

  def md_link(repo) when is_binary(repo) do
    "[#{short_url(repo)}](#{repo})"
  end

  def short_url(repo) do
    repo |> String.replace("https://github.com/", "")
  end

  def lastcommit_short(stats) do
    String.slice(stats.lastcommit, 0, 10)
  end
end
