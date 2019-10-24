defmodule Updater.MarkdownFormatterTest do
  use ExUnit.Case
  alias Updater.MarktdownFormatter

  def stats() do
    %{
      repo: "https://github.com/rails/rails",
      commitscount: 69222,
      description: "Ruby on Rails",
      lastcommit: "2018-06-20T12:52:09Z",
      stars: 39960
    }
  end

  test "activity formatting" do
    assert MarktdownFormatter.activity(stats()) ==
             "- [rails/rails](https://github.com/rails/rails) - Ruby on Rails <br/> ( 2018-06-20 / 69222 commits / 39960 stars )"
  end

  test "project formatting" do
    assert MarktdownFormatter.project(stats()) ==
             "- [rails/rails](https://github.com/rails/rails) - Ruby on Rails <br/> ( 2018-06-20 / 69222 commits / 39960 stars )"
  end

  test "md_link" do
    assert MarktdownFormatter.md_link(stats()) ==
             "[rails/rails](https://github.com/rails/rails)"
  end

  test "short_url" do
    assert MarktdownFormatter.short_url(stats() |> Map.get(:repo)) == "rails/rails"
  end
end
