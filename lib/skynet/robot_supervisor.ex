defmodule Skynet.RobotSupervisor do
  require Logger
  use Supervisor

  alias Skynet.KillerRobot

  def start_link(_opts) do
    Logger.info "A new evil robot army has been spawned!"

    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    robots = [
      worker(KillerRobot, [], restart: :transient)
    ]

    supervise(robots, strategy: :simple_one_for_one)
  end

  def robots do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(&(elem(&1,1)))
    |> Enum.map(&KillerRobot.name(&1))
  end

  def start_robot do
    Supervisor.start_child(__MODULE__, [Skynet.NameGenerator.generate_name])
  end

  def kill_robot(name) do
    KillerRobot.stop_robot(name)
  end
end
