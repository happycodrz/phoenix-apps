defmodule Updater.Git do
  def download(repo) do
    if was_downloaded?(repo) do
      update(repo)
    else
      clone(repo)
    end
  end

  # https://github.com/AndrewDryga/talk_sagas_of_elixir
  def local_path(url) do
    path = url |> String.split("//") |> Enum.at(1) |> String.downcase()
    "src/#{path}"
  end

  defp update(repo) do
    IO.puts("updating #{repo} to #{local_path(repo)}")
    cmd = "cd #{local_path(repo)} && git reset --hard && git pull"
    Updater.Shell.run(cmd)
  end

  defp clone(repo) do
    IO.puts("cloning #{repo} to #{local_path(repo)}")
    cmd = "git clone #{repo} #{local_path(repo)}"
    Updater.Shell.run(cmd)
  end

  defp was_downloaded?(url) do
    File.exists?(url |> local_path())
  end
end
