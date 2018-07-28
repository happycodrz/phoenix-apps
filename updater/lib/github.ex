defmodule Updater.Github do
  import Mockery.Macro

  def get(repo) do
    mockable(Tesla).get(repo)
  end
end
