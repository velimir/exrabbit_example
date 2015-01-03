defmodule ExrabbitExample.Worker do
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
    # conn_opts: [qos: basic_qos(prefetch_count: 1)]

  use GenServer

  def start_link(name, sleep) do
    ref_name = Module.concat(__MODULE__, String.replace(name, ~r/\s+/, "_"))
    GenServer.start_link(__MODULE__, [name, sleep], name: ref_name)
  end

  init [name, sleep] do
    {:ok, [name, sleep]}
  end

  on %Message{body: body}, [name, sleep] do
    Logger.info "Worker (#{name}) received and promised to acknowledge #{body}"
    :timer.sleep(sleep)
    Logger.info "Worker (#{name}) processed #{body}"
    {:ack, [name, sleep]}
  end
end
