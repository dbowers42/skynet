defmodule Skynet.Application do
  require Logger
  use Application
  alias Skynet.RobotSupervisor
  alias Skynet.NameGenerator

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(RobotSupervisor, [[name: Skynet.RobotSupervisor, restart: :transient]]),
      worker(NameGenerator, [])
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
