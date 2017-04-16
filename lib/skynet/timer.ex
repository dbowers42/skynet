defmodule Skynet.Timer do
  require Logger
  use GenServer

  def start_link(timer_id) do
    Logger.debug "start timer for >> #{timer_id}"
    GenServer.start_link(fn -> %{start_time: NaiveDateTime.utc_now()} end, name: via_tuple(timer_id))
  end

  def start_time(timer_id) do
    GenServer.call(via_tuple(timer_id), :start_time)
  end

  def elapsed_time(timer_id) do
    time = NaiveDateTime.utc_now()
    NaiveDateTime.diff(time, start_time(via_tuple(timer_id)), :millisecond)
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

  defp via_tuple(timer_id) do
    {:via, :gproc, {:n, :l, {:robot_timer, timer_id}}}
  end
end
