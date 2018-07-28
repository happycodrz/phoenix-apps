defmodule Updater.ReadmeHandler do
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

  def replace_projects(projects, content) do
    projects = Enum.sort_by(projects, fn(x)-> x.repo end)
    pattern = Regex.compile!("(?s)<!-- PROJECTS_LIST -->(.*)<!-- /PROJECTS_LIST -->")
    regexStart = "<!-- PROJECTS_LIST -->"
    regexEnd = "<!-- /PROJECTS_LIST -->"
    block = projects |> Enum.map(&Updater.MarktdownFormatter.project/1) |> Enum.join("\n")
    block = regexStart <> "\n" <> block <> "\n" <> regexEnd
    Regex.replace(pattern, content, block)
  end

  def replace_activity(projects, content) do
    projects = Enum.sort_by(projects, fn(x)-> x.lastcommit end) |> Enum.reverse
    pattern = Regex.compile!("(?s)<!-- ACTIVITY_LIST -->(.*)<!-- /ACTIVITY_LIST -->")
    regexStart = "<!-- ACTIVITY_LIST -->"
    regexEnd = "<!-- /ACTIVITY_LIST -->"
    block = projects |> Enum.map(&Updater.MarktdownFormatter.activity/1) |> Enum.join("\n")
    block = regexStart <> "\n" <> block <> "\n" <> regexEnd
    Regex.replace(pattern, content, block)
  end
end

defmodule Updater.MarktdownFormatter do
  def activity(stats) do
    "- #{md_link(stats)}: #{lastcommit_short(stats)}  <br/>  #{stats.description}"
  end

  def project(stats) do
    "- #{md_link(stats)} - #{stats.description} <br/> ( #{lastcommit_short(stats)} / #{
      stats.commitscount
    } commits / #{stats.stars} stars )"
  end

  def md_link(stats) do
    "[#{short_url(stats)}](#{stats.repo})"
  end

  def short_url(stats) do
    stats |> Map.get(:repo) |> String.replace("https://github.com/", "")
  end

  def lastcommit_short(stats) do
    String.slice(stats.lastcommit, 0, 10)
  end
end
