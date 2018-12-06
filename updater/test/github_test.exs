defmodule Updater.GithubTest do
  import Mockery
  use ExUnit.Case
  alias Updater.Github

  test "mock any function :get from Updater.Github" do
    mock(Tesla, [get: 1], fn value -> String.upcase(value) end)
    assert Github.get("bla") == "BLA"
  end

  test "mock any function :get from Updater.Github-2" do
    mock(Tesla, [get: 1], fn value -> String.upcase(value) <> "-2" end)
    assert Github.get("bla") == "BLA-2"
  end
end
