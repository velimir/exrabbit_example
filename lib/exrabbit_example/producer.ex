defmodule ExrabbitExample.Producer do
  require Record
  Record.defrecord :state, [freq: nil, producer: nil, count: 0]

  use Exrabbit.Records
  alias Exrabbit.Producer
  require Logger
  
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [opts], name: __MODULE__)
  end

  def init([freq_ms]) do
    exchange = exchange_declare(
      exchange: "exrabbit_example_ex",
      type: "direct",
      durable: true
    )

    producer = %Producer{chan: chan} = Producer.new(exchange: exchange)
    Exrabbit.Channel.set_mode(chan, :confirm)
    
    {:ok, state(freq: freq_ms, producer: producer), 0}
  end

  def terminate(reason, state(producer: producer)) do
    Logger.info "producer is going to be terminated right now with a reason: #{inspect reason}"
    Producer.shutdown(producer)
  end

  def handle_call(_event, state) do
    {:noreply, state}
  end

  def handle_cast(:produce, state(producer: producer, count: count) = rec) do
    Logger.info "producer is going to produce new message [#{count}]"
    Producer.publish(producer, "deal with #{count}", await_confirm: true)
    {:noreply, rec}
  end

  def handle_info(:produce, state(freq: freq, count: count) = rec) do
    Logger.info "received handle_info :produce with state: #{inspect rec}"
    GenServer.cast(__MODULE__, :produce)
    Process.send_after(__MODULE__, :produce, freq)
    {:noreply, state(rec, count: count + 1)}
  end
  def handle_info(:timeout, state(freq: freq, count: count) = rec) do
    Logger.info "received handle_info :timeout with state: #{inspect rec}"
    Process.send_after(__MODULE__, :produce, freq)
    {:noreply, rec}
  end
  
end
