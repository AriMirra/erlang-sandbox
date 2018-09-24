defmodule Broker do
  @moduledoc false

  def loop() do
    loop(Map.new)
  end

  defp loop(map) do
    receive do
      {from, :crear_accion, name, value} ->
        cond do
          Map.has_key? map, name ->
            send from, {self(), :key_already_in_use}
            loop map
          true ->
            send from, {self(), :ok}
            loop Map.put map, name, [value]
        end

        {from, :consultar_valor, name} ->
          cond do
            Map.has_key? map, name ->
              send from, { {self(), :ok, Map.fetch!(map,name) |> List.first} }
              loop map
            true ->
              send from, {self(), :not_found}
              loop map
          end

      {from, :cambiar_cotizacion, name, value} ->
        cond do
          Map.has_key? map, name ->
            send from, {self(), :ok}
            loop Map.replace! map, name, [value | Map.fetch!(map,name)]
          true ->
            send from, {self(), :not_found}
            loop map
        end

      {from, :consultar_historia, name} ->
        cond do
          Map.has_key? map,name ->
            send from, {self(), :ok, Map.fetch!(map,name)}
            loop map
          true ->
            send from, {self(), :not_found}
            loop map
        end

    end

  end

end
