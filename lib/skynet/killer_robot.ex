defmodule Skynet.KillerRobot do
  require Logger

  use GenServer

  def start_link(robot_id) do
    Logger.info "A new killer robot has been spawned"
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

  defp via_tuple(robot_id) do
       {:via, :gproc, {:n, :l, {:evil_robots, robot_id}}}
  end
end
