defmodule Skynet.NameGenerator do
  @adjectives [
    "Mean",
    "Scheming",
    "Rude",
    "Agressive",
    "Unpleasant",
    "Dirty",
    "Mean",
    "Ruthless",
    "Stinky",
    "Bitter",
    "Spiteful",
    "Sloppy",
    "Angry",
    "Jealous",
    "Itchy",
    "Obstreperous",
    "Obnoxious",
    "Scurvy",
    "Nasty",
    "Toothy"
  ]

  @names [
    "Bob",
    "Dave",
    "Stan",
    "Harry",
    "Jake",
    "Sanchez",
    "Rasputan",
    "Caligula",
    "Jim",
    "Jack",
    "Steve",
    "Pete",
    "Dan",
    "Joe",
    "Nero",
    "Dante",
    "Gilbert",
    "Zak",
    "Bill",
    "Fred"
  ]

  def start_link do
    Agent.start_link(fn -> %{count: 0} end, name: __MODULE__)
  end

  def generate_name do
    increment()
    "#{adjective()} #{name()} #{count()}"
  end

  defp count() do
    Agent.get(__MODULE__, &Map.get(&1, :count))
  end

  defp increment() do
  Agent.update(__MODULE__, &Map.put(&1, :count,  &1.count + 1))
  end

  defp adjective do
    index = :rand.uniform(length(@adjectives) - 1)
    Enum.at(@adjectives, index)
  end

  defp name do
    index = :rand.uniform(length(@names) - 1)
    Enum.at(@names, index)
  end
end
