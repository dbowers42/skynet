defmodule Skynet.RobotSupervisor do
  require Logger
  use Supervisor

  alias Skynet.KillerRobot

  def start_link(_opts) do
    Logger.info "A new evil robot army has been spawned!"
    Supervisor.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
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

  def kill_robots do
    tasks = robots() |> Enum.map(&Task.async(Skynet.KillerRobot, :try_kill_robot, [&1]))
    Task.yield_many(tasks, kill_timeout())
  end

  def spawn_robots do
    tasks = robots() |> Enum.map(&Task.async(Skynet.KillerRobot, :try_reproduce_robot, [&1]))
    Task.yield_many(tasks, reproduce_timeout())
  end

  def run do
    spawn_task = Task.async(&spawn_robots/0)
    kill_task = Task.async(&kill_robots/0)
    Task.yield_many([spawn_task, kill_task], run_timeout())
    run()
  end

  def kill_robot(name) do
    KillerRobot.stop_robot(name)
  end

  def handle_cast({:pid, pid}, state) do
    {:noreply, %{state | pid: pid}}
  end

  def handle_call(:pid, _from, state) do
    {:reply, state.pid, state}
  end

  defp kill_timeout do
    count = robots()
    |> Enum.count()

    count * (KillerRobot.kill_robot_time_limit() + 100)
  end

  defp reproduce_timeout do
    count = robots()
    |> Enum.count()

    count * (KillerRobot.reproduce_robot_time_limit() + 100)
  end

  defp run_timeout do
    reproduce_timeout() + 100 + kill_timeout() + 100
  end
end
