defmodule Skynet do
  alias Skynet.RobotSupervisor

  def robots do
    RobotSupervisor.robots()
  end

  def spawn_robot do
    RobotSupervisor.start_robot()
  end

  def kill_robot(robot) do
    RobotSupervisor.kill_robot(robot)
  end

  def hunt_robots do
    Skynet.RobotRunner.restart()
  end
end
