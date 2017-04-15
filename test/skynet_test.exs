defmodule SkynetTest do
  use ExUnit.Case
  doctest Skynet

  test "it returns a list of robots" do
    Skynet.spawn_robot()
    Skynet.spawn_robot()
    Skynet.spawn_robot()

    assert Skynet.robots()|> Enum.count() == 3
  end

  test "it spawns another robot" do
    {status, _} = Skynet.spawn_robot()

    assert status == :ok
  end
end
