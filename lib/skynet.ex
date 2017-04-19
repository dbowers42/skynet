require Logger

defmodule Skynet do
  use GenServer
  alias Skynet.RobotSupervisor

  def start_link(node_id) when is_atom(node_id) do
    GenServer.start_link(__MODULE__, %{node_id: node_id}, name: __MODULE__)
  end

  def connect() do
    Node.connect(active_node())
  end

  def run(node_id) do
    start_link(node_id)
    connect()
  end

  def active_node do
    GenServer.call(__MODULE__, :node_id)
  end

  def robots do
    RobotSupervisor.robots() |> Logger.info
  end

  def spawn_robot do
    Node.spawn(active_node(), Skynet.RobotSupervisor, :start_robot, [])
  end

  def kill_robot(robot) do
    Node.spawn(active_node(), Skynet.RobotSupervisor, :kill_robot, [robot])
  end

  def hunt_robots do
    Node.spawn(active_node(), Skynet.RobotRunner, :restart, [])
  end

  def handle_call(:node_id, _from, state) do
    {:reply, state.node_id, state}
  end
end
