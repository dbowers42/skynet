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

on the command line execute

```
iex -S mix
```
In iex it might be useful to do this

```elixir
  import Skynet
```

once you have done that you call:

robots()          -- to list all remaining robots
spawn_robot()     -- to create new robot with a random name
kill_robot(robot) -- destroy a robot by its name
hunt_robots()     -- to begin hunting robots if they have already been eliminated

Note: currently when you start the app it will say that Sarah Connor has killed
all remaining robots. That is because the app starts with 0 robots. Ideally there
are specific improvements I would like to make to interacting with the
app. I have limited time to make those improvements right now, but we can
certainly talk about what I would like to change.
