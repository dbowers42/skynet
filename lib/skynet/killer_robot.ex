defmodule Skynet.KillerRobot do
  @kill_robot_time_limit 10      # try to kill a robot every 10 seconds
  @kill_robot_odds 4             # 25% of a robot being killed 1 in 4
  @reproduce_robot_time_limit 5  # Try to reproduce every 5 seconds
  @reproduce_robot_odds 5        # 20% of chance of robot reproducing 1 in 5

  require Logger
  alias Skynet.RobotSupervisor

  use GenServer

  def start_link(robot_id) do
    Logger.info "A new killer robot has been spawned >> #{robot_id}"
    GenServer.start_link(__MODULE__, %{robot_id: robot_id}, name: via_tuple(robot_id))
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
    Process.sleep(kill_robot_time_limit())

    if kill_robot?() do
        RobotSupervisor.kill_robot(robot_id)
        Logger.info "Sarah Conner has just killed #{robot_id}!"
    end
  end

  def try_reproduce_robot(robot_id) do
    Process.sleep(reproduce_robot_time_limit())

    if reproduce?() do
        RobotSupervisor.start_robot()
        Logger.info "#{robot_id} has just reproduced!"
    end
  end

  def kill_robot_time_limit do
    @kill_robot_time_limit * 1000
  end

  def reproduce_robot_time_limit do
    @reproduce_robot_time_limit * 1000
  end

  defp kill_robot? do
    :rand.uniform(@kill_robot_odds) == @kill_robot_odds
  end

  defp reproduce? do
    :rand.uniform(@reproduce_robot_odds) == @reproduce_robot_odds
  end

  defp via_tuple(robot_id) do
    {:via, :gproc, {:n, :l, {:evil_robots, robot_id}}}
  end
end
