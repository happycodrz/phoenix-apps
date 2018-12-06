defmodule Updater.CrawlerTest do
  import Mockery
  alias Updater.Crawler
  use ExUnit.Case
  doctest Crawler

  setup do
    case :ets.info(:fixture_cache) do
      :undefined -> :ets.new(:fixture_cache, [:named_table])
      _ -> nil
    end

    {:ok, %{}}
  end

  def fixture(file) do
    case :ets.lookup(:fixture_cache, file) do
      [{^file, content}] ->
        {:ok, content}

      [] ->
        content = "test/fixtures/#{file}" |> File.read!() |> Floki.parse()
        :ets.insert(:fixture_cache, {file, content})
        {:ok, content}
    end
  end

  test "description" do
    {:ok, body} = fixture("rails.html")
    assert Crawler.description(body) == "Ruby on Rails"
  end

  test "lastcommit - included" do
    {:ok, body} = fixture("rails.html")
    assert Crawler.lastcommit(body) == "2018-06-20T12:52:09Z"
  end

  test "lastcommit - ajax loaded" do
    {:ok, body} = fixture("rails-86e42b53662f535ee484630144e27ee684e8e8dc.html")
    assert Crawler.lastcommit(body) == "2018-06-06T17:17:53Z"
  end

  test "stars" do
    {:ok, body} = fixture("rails.html")
    assert Crawler.stars(body) == 39960
  end

  test "stats" do
    {:ok, body} = fixture("rails.html")
    mock(Tesla, [get: 1], {:ok, %{body: body, status: 200}})

    expected = %{
      repo: "https://github.com/rails/rails",
      commitscount: 69222,
      description: "Ruby on Rails",
      lastcommit: "2018-06-20T12:52:09Z",
      stars: 39960
    }

    assert Crawler.stats("https://github.com/rails/rails") == expected
  end
end
