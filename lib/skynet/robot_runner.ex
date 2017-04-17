defmodule Skynet.RobotRunner do
  require Logger
  use GenServer

  alias Skynet.RobotSupervisor

  def start_link do
    Logger.info "Welcome to Skynet!"
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    Skynet.RobotSupervisor.run()
    {:ok, state}
  end

  def restart() do
    Skynet.RobotSupervisor.run()
  end
end
