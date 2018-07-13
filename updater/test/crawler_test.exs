defmodule Updater.CrawlerTest do
  import Mockery
  alias Updater.Crawler
  use ExUnit.Case
  doctest Crawler

  def fixture(file) do
    "test/fixtures/#{file}" |> File.read!()
  end

  test "description" do
    body = fixture("rails.html")
    assert Crawler.description(body) == "Ruby on Rails"
  end

  test "lastcommit - ajax loaded" do
    body = fixture("rails.html")
    # body = fixture("rails-86e42b53662f535ee484630144e27ee684e8e8dc.html")
    assert Crawler.lastcommit(body) == "2018-06-20T12:52:09Z"
  end

  test "lastcommit - included" do
    body = fixture("rails-86e42b53662f535ee484630144e27ee684e8e8dc.html")
    assert Crawler.lastcommit(body) == "2018-06-06T17:17:53Z"
  end

  test "stats" do
    mock(SimpleHttp, [get: 1], {:ok, %{body: fixture("rails.html")}})

    expected = %{
      commitscount: 69222,
      description: "Ruby on Rails",
      lastcommit: "2018-06-20T12:52:09Z",
      stars: 39960
    }

    assert Crawler.stats("https://github.com/rails/rails") == expected
  end
end
