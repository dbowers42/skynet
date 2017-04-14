defmodule Skynet.KillerRobot do
  require Logger

  use GenServer

  def start_link do
    Logger.info "A new killer robot has been spawned"
    GenServer.start_link(__MODULE__, :ok)
  end
end
