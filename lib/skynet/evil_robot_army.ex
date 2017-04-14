defmodule Skynet.EvilRobotArmy do
  require Logger

  use Supervisor

  def start_link() do
    Logger.info "A new evil robot army has been spawned!"
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    supervise([], strategy: :simple_one_for_one)
  end
end
