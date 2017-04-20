# Skynet

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `skynet` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:skynet, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/skynet](https://hexdocs.pm/skynet).

## Running

#### Create two terminal windows

  In the first terminal window execute ```make server```.  Next, in the second terminal window execute ```make client```. The second terminal window will start an IEX session. Nothing will be happening at first, but you can interact with the IEX session.

  #### Here are some commands

  <table>
    <tr>
      <th>Command</th>
      <th>Action</th>
    </tr>
    <tr>
      <td>Skynet.Client.start()</td>
      <td><b>Always run this first</b> - starts up a new session to interact with skynet</td>
    </tr>
    <tr>
      <td>Skynet.Client.spawn_robot()</td>
      <td>Spawns a new killer robot with a random name</td>
    </tr>
    <tr>
      <td>Skynet.Client.kill_robot(robot)</td>
      <td>Destroys a killer robot with a matching name</td>
    </tr>
    <tr>
      <td>Skynet.Client.robots()</td>
      <td>Displays a list of robots that still remain alive</td>
    </tr>
  </table>
