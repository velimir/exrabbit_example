defmodule ExrabbitExample do
  use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Define workers and child supervisors to be supervised
      worker(ExrabbitExample.Worker, ["Foo", 5000], id: :"Foo Worker"),
      worker(ExrabbitExample.Worker, ["Bar", 2000], id: :"Bar Worker"),
      worker(ExrabbitExample.BadWorker, ["Bad Worker"]),
      worker(ExrabbitExample.Producer, [1000])
    ]
    
    opts = [strategy: :one_for_one, name: ExrabbitExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
