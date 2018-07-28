defmodule Mix.Tasks.Update do
  use Mix.Task

  @shortdoc "Runs the Updater.run/0 function"
  def run(_) do
    Updater.Sorter.sort
    Updater.run
  end
end
