defmodule Skynet.RobotSupervisor do
  require Logger
  use Supervisor

  alias Skynet.KillerRobot

  def start_link(_opts) do
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

    display_remaining_robots()
  end

  def display_remaining_robots do
    case robot_count() do
      1 ->
        Logger.info "Just 1 robot remains alive!"
        run()
      0 ->
        Logger.info "Sarah Connor has killed all the robots!"
      _ ->
        Logger.info "#{robot_count()} robots still remain alive"
        run()
    end
  end

  def kill_robot(name) do
    KillerRobot.stop_robot(name)
  end

  def handle_cast({:pid, pid}, state) do
    {:noreply, %{state | pid: pid}}
  end

  defp robot_count do
    robots() |> Enum.count()
  end

  def handle_call(:pid, _from, state) do
    {:reply, state.pid, state}
  end

  defp kill_timeout do
    robot_count() * (KillerRobot.kill_robot_time_limit() + 100)
  end

  defp reproduce_timeout do
    robot_count() * (KillerRobot.reproduce_robot_time_limit() + 100)
  end

  defp run_timeout do
    reproduce_timeout() + 100 + kill_timeout() + 100
  end
end
