defmodule FooEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :foo_ecto,
      version: "0.1.0",
      elixir: "~> 1.16",
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      foo(),
      {:hackney, "~> 1.9"},
    ]
  end

  defp foo() do
    case System.get_env("FOO_DEP") do
      "LOCAL" -> {:foo, path: "../foo"}
      _ -> {:foo, git: "https://github.com/rmoorman/elixir-monorepo-test.git", sparse: "package/foo"}
    end
  end
end
