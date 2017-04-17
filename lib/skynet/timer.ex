defmodule Skynet.Timer do
  require Logger
  use GenServer

  def start_link(timer_id) do
    Logger.debug "start timer for >> #{timer_id}"
    GenServer.start_link(__MODULE__, %{start_time: NaiveDateTime.utc_now(), timer_id: timer_id}, name: via_tuple(timer_id))
  end

  def start_time(timer_id) do
    GenServer.call(via_tuple(timer_id), :start_time)
  end

  def elapsed_time(timer_id) do
    Logger.debug "Get elapsed time for >> #{timer_id}"
    time = NaiveDateTime.utc_now()
    abs(NaiveDateTime.diff(time, start_time(timer_id), :millisecond))
  end

  def timer_id(pid) do
    GenServer.call(pid, :timer_id)
  end

  def reset(timer_id) do
    GenServer.cast(via_tuple(timer_id), :reset)
  end

  def handle_call(:start_time, _from, state) do
      {:reply, state.start_time, state}
  end

  def handle_cast(:reset, state) do
    {:noreply, %{state | start_time: NaiveDateTime.utc_now()}}
  end

  def handle_call(:timer_id, _from, state) do
    {:reply, state.timer_id, state}
  end

  defp via_tuple(timer_id) do
    {:via, :gproc, {:n, :l, {:robot_timer, timer_id}}}
  end
end
