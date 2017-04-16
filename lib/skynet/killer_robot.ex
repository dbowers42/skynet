defmodule Skynet.KillerRobot do
  # @kill_robot_time_limit 10        # try to kill a robot every 10 seconds
  # @kill_robot_odds 25              # 25% of a robot being killed
  # @reproduce_robot_time_limit 5000 # Try to reproduce every 5 seconds
  # @reproduct_robot_odds 20         # 20% of of robot reproducing

  require Logger
  alias Skynet.Timer
  alias Skynet.TimerSupervisor

  use GenServer

  def start_link(robot_id) do
    Logger.info "A new killer robot has been spawned >> #{robot_id}"
    result = GenServer.start_link(__MODULE__, %{robot_id: robot_id}, name: via_tuple(robot_id))

    TimerSupervisor.add_timer(robot_id, kill_timer_name(robot_id))
    TimerSupervisor.add_timer(robot_id, reproduce_timer_name(robot_id))

    try_kill_robot(robot_id)
    try_reproduce_robot(robot_id)

    result
  end

  def init(state) do
    Logger.debug "init >> #{state.robot_id}"
    import Supervisor.Spec, warn: false

    children = [
      supervisor(TimerSupervisor, [state.robot_id])
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end

  def stop_robot(robot_id) do
    GenServer.stop(via_tuple(robot_id))
  end

  def name(pid) do
    GenServer.call(pid, :name)
  end

  def handle_call(:name, _from, state) do
    {:reply, state.robot_id, state}
  end

  def try_kill_robot(robot_id) do
    Logger.debug "try kill robot >> #{robot_id}"
    Timer.start_time(kill_timer_name(robot_id)) |> IO.inspect
  end

  def try_reproduce_robot(robot_id) do
    Logger.debug "try reproduce robot >> #{robot_id}"
    TimerSupervisor.timers(robot_id) |> IO.inspect
  end

  defp reproduce_timer_name(robot_id) do
    "reproduce timer: #{robot_id}"
  end

  defp kill_timer_name(robot_id) do
    "kill timer: #{robot_id}"
  end

  defp via_tuple(robot_id) do
    {:via, :gproc, {:n, :l, {:evil_robots, robot_id}}}
  end
end
