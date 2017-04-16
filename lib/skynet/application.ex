defmodule Skynet.Application do
  require Logger
  use Application
  alias Skynet.RobotSupervisor
  alias Skynet.NameGenerator

  def make_robot do
    job = fn ->
      Process.sleep(1000)
      IO.puts "make robot"
    end

    spawn(job)
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(RobotSupervisor, [[name: Skynet.RobotSupervisor, restart: :transient]]),
      worker(NameGenerator, [])
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)

    for _ <- 1..3 do
      RobotSupervisor.start_robot()
    end




    {:ok, self()}
  end
end
