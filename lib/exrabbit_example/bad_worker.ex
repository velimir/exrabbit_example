defmodule ExrabbitExample.BadWorker do
  require Logger
  
  use Exrabbit.Consumer.DSL,
    exchange: exchange_declare(
      exchange: "exrabbit_example_ex",
      type: "direct",
      durable: true
    ),
    queue: queue_declare(
      queue: "exrabbit_example_q",
      durable: true
    ),
    no_ack: false

  use GenServer

  def start_link(name) do
    ref_name = Module.concat(__MODULE__, String.replace(name, ~r/\s+/, "_"))
    GenServer.start_link(__MODULE__, [name], name: ref_name)
  end

  init [name] do
    {:ok, name}
  end

  on %Message{body: body}, name do
    Logger.info "Woker (#{name}) received and promised to acknowledge #{body}"
    raise "Accidentally failed"
    Logger.info "Worker (#{name}) processed #{body}"
    {:ack, name}
  end

end
