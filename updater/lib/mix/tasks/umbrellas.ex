defmodule Mix.Tasks.Umbrellas do
  use Mix.Task

  @shortdoc "Shows which of cloned repos could be an umbrella project"
  def run(_) do
    IO.puts("Grep-ing for umbrellas, please stay patient...")

    umbrellas =
      UmbrellaFinder.run()
      |> IO.inspect()
      |> Updater.ReadmeHandler.replace_umbrellas!()
  end
end
