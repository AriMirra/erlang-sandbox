defmodule Length do
  @moduledoc false

  def length(l) do
    length(l,0)
  end

  defp length([_ | t], acc) do
    length t, acc + 1
  end

  defp length([], acc) do
    acc
  end
end
