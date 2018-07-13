defmodule Updater.Shell do
  def run(cmd) do
    :os.cmd(cmd |> String.to_charlist()) |> List.to_string()
  end
end
