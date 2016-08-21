defmodule Calc.Stash do
  use GenServer

  ## External API
  def start_link(current_value) do
    {:ok, pid} = GenServer.start_link(__MODULE__, current_value)
  end

  def save_value pid, value do
    GenServer.cast pid, {:save_value, value}
  end

  def get_value pid do
     IO.inspect(pid)
     GenServer.call pid, :get_value
  end

  ## GenServer
  def handle_cast {:save_value, value}, _current_value do
    {:noreply, value}
  end

  def handle_call(:get_value, _, current_value) do
    {:reply, current_value, current_value}
  end

end
