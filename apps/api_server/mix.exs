defmodule ApiServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :api_server,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {ApiServer, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:db, in_umbrella: true},
      {:mailer, in_umbrella: true},
      {:plug_cowboy, "~> 2.0.0"},
      {:token, in_umbrella: true},
      {:utils, in_umbrella: true}
    ]
  end
end
