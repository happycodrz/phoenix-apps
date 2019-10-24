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
