defmodule Calc.Calculator do
  use GenServer

  ## API
  def start_link(stash_pid) do
    {:ok, pid} = GenServer.start_link(__MODULE__, stash_pid, [debug: [:trace], name: __MODULE__])
  end

  def value do
    GenServer.call(__MODULE__, :value)
  end

  def exec(operator, n) do
    GenServer.cast(__MODULE__, {operator, n})
  end

  def perform_calculation(value, operator, n) do
    case operator do
      :+ -> value + n
      :- -> value - n
    end
  end

  ## GenServer
  def init(stash_pid) do
    current_value = Calc.Stash.get_value(stash_pid)
    {:ok, {current_value, stash_pid}}
  end

  def handle_call :value, _, {value, stash_pid} do
    {:reply, value, {value, stash_pid}}
  end

  def handle_cast {operator, n}, {value, stash_pid} do
    {:noreply, { perform_calculation(value, operator, n), stash_pid}}
  end

  def terminate(_reason, {current_value, stash_pid}) do
    Calc.Stash.save_value(stash_pid, current_value)
  end

end
