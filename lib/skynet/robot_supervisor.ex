defmodule Skynet.RobotSupervisor do
  require Logger
  use Supervisor

  alias Skynet.KillerRobot

  def start_link(_opts) do
    Logger.info "A new evil robot army has been spawned!"
    result = Supervisor.start_link(__MODULE__, %{}, name: __MODULE__)
    run()

    result
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

    for task <- tasks do
      Task.await(task, KillerRobot.kill_robot_time_limit() + 100)
      IO.puts "done killing"
    end
    IO.inspect "complete killing"
  end

  def spawn_robots do
    tasks = robots() |> Enum.map(&Task.async(Skynet.KillerRobot, :try_reproduce_robot, [&1]))

    for task <- tasks do
      Task.await(task, KillerRobot.reproduce_robot_time_limit)
      IO.puts "done reproducing"
    end
    IO.inspect "complete reproducing"
  end

  def run do
    kill_robots
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
end
