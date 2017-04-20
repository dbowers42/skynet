require Logger

defmodule Skynet.Client do
  use GenServer

  alias Skynet.RobotSupervisor

  def start do
    node_id = System.get_env("SKYNET_SERVER_NODE") |> String.to_atom()
    GenServer.start(__MODULE__, node_id, name: __MODULE__)
  end

  def robots do
    Node.spawn(node_id(), RobotSupervisor, :display_robots, [])
  end

  def spawn_robot do
    Node.spawn(node_id(), RobotSupervisor, :start_robot, [])
  end

  def kill_robot(robot) do
    Node.spawn(node_id(), RobotSupervisor, :kill_robot, [robot])
  end

  def handle_call(:node_id, _from, state) do
    {:reply, state, state}
  end

  def node_id do
    GenServer.call(__MODULE__, :node_id)
  end
end
