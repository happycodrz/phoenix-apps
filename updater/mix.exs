defmodule Updater.MixProject do
  use Mix.Project

  def project do
    [
      app: :updater,
      version: "0.1.0",
      elixir: "~> 1.7-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cortex, "~> 0.5"},
      {:flexi, "~> 0.3"},
      {:floki, "~> 0.20.0"},
      {:tesla, "~> 1.0.0"},
      {:mockery, "~> 2.2.0", runtime: false}
    ]
  end
end
