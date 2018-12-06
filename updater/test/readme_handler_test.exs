defmodule Updater.ReadmeHandlerTest do
  use ExUnit.Case
  alias Updater.{ReadmeHandler, MarktdownFormatter}

  describe "ReadmeHandler" do
    def projects do
      [
        %{
          repo: "https://github.com/rails/rails",
          commitscount: 69222,
          description: "Ruby on Rails",
          lastcommit: "2018-06-20T12:52:09Z",
          stars: 39960
        },
        %{
          repo: "https://github.com/elixir/elixir",
          commitscount: 10000,
          description: "Elixir",
          lastcommit: "2018-07-20T12:52:09Z",
          stars: 66666
        }
      ]
    end

    test "replace_activity" do
      content = File.read!("../Readme.md")
      projects = projects()
      # assert ReadmeHandler.replace_activity(projects, content) == ""
    end

    test "replace_projects" do
      content = File.read!("../Readme.md")
      projects = projects()
      # assert ReadmeHandler.replace_projects(projects, content) == ""
    end
  end

  describe "MarktdownFormatter" do
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
      assert MarktdownFormatter.short_url(stats()) == "rails/rails"
    end
  end
end
