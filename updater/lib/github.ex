defmodule Updater.Github do
  import Mockery.Macro

  def get(repo) do
    mockable(SimpleHttp).get(repo)
  end
end
