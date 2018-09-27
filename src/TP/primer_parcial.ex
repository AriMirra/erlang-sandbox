defmodule PrimerParcial do
  @moduledoc false

  def loop() do
    loop(List.new)
  end

  def loop(list) do
    receive do
      {from, {:store, item}} ->
        send from, {self(), :ok}
        loop [item | list]

      {from, {:take, item}} ->
        if Enum.member? list item do
          send from, {self(), :ok}
          loop List.delete(list,item)
        else
          send from, {self(), :not_found}
          loop list
        end

      {from, {:list}} ->
        send from, {self(), :ok, list}
        loop list

      { from, {:terminate} } ->
        send from, {self(), :ok}
    end
  end

  def len(list) do
    len(list, 0)
  end

  defp len([head | tail], acc) do
    len(tail, acc + 1)
  end

  defp len([], acc) do
    acc
  end
end
