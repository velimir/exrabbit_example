defmodule ExrabbitExample.Mixfile do
  use Mix.Project

  def project do
    [app: :exrabbit_example,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
        mod: { ExrabbitExample, [] },
        applications: [:logger, :exrabbit],
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
        {:exrabbit, github: "velimir0xff/exrabbit", branch: "master"}
    ]
  end
end
