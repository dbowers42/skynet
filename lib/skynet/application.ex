defmodule Skynet.Application do
  require Logger
  use Application
  alias Skynet.RobotSupervisor
  alias Skynet.NameGenerator
  alias Skynet.RobotRunner

  def start(_type, _args) do
    skynet_server_node = System.get_env("SKYNET_SERVER_NODE") |> String.to_atom()
    skynet_node_type = System.get_env("SKYNET_NODE_TYPE") |> String.to_atom()

    case skynet_node_type do
      :server ->
        Logger.info "Running Server #{node()}"
        import Supervisor.Spec, warn: false

        children = [
          supervisor(RobotSupervisor, [[name: Skynet.RobotSupervisor, restart: :transient]]),
          worker(NameGenerator, []),
          worker(RobotRunner, [])
        ]

        Supervisor.start_link(children, strategy: :one_for_one)
      :client ->
        Logger.info "Running Client #{node()}"
        Node.connect(skynet_server_node)
        {:ok, self()}
    end
  end
end
