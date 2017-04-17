defmodule Skynet.TimerSupervisor do
  require Logger
  alias Skynet.Timer
  use Supervisor

  def start_link(robot_id) do
    Logger.debug "Starting timer supervisor for >> #{robot_id}"
    Supervisor.start_link(__MODULE__, %{robot_id: robot_id}, name: via_tuple(robot_id))
  end

  def init(_) do
    timers = [
      worker(Timer, [])
    ]
    supervise(timers, strategy: :simple_one_for_one)
  end

  def timers(robot_id) do
    Supervisor.which_children(via_tuple(robot_id))
    |> Enum.map(&(elem(&1,1)))
    |> Enum.map(&Timer.timer_id(&1))
  end

  def add_timer(robot_id, timer_id) do
    Supervisor.start_child(via_tuple(robot_id), [timer_id])
  end

  defp via_tuple(robot_id) do
    {:via, :gproc, {:n, :l, {:timer_supervisor, robot_id}}}
  end
end
