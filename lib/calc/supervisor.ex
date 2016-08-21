defmodule Calc.Supervisor do
  use Supervisor

  def start_link(initial_value) do
    # Start the main Supervisor
    result = {:ok , sup} = Supervisor.start_link(__MODULE__, [initial_value])
    start_workers(sup, initial_value)
    result
  end

  def start_workers(sup, initial_value) do
    # Supervise the stash worker
    {:ok, stash_pid} = Supervisor.start_child(sup, worker(Calc.Stash, [initial_value]))
    # Start the subsupervisor that will start the Calc.Worker
    Supervisor.start_child(sup, supervisor(Calc.WorkerSupervisor, [stash_pid]))
  end

  def init _ do
    supervise [], strategy: :one_for_one
  end

end
