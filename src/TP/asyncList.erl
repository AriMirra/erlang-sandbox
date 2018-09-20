-module(asyncList).
-author("arielmirra").

%% API
-export([loop/0]).

loop() -> loop([]).

loop(List) ->
  receive
    { From, {store, Item} } ->
      From ! {self(), ok},
      loop([Item | List]);

    { From, {take, Item} } ->
      case lists:member(Item,List) of
        true ->
          From ! {self(), {ok, Item}},
          loop(lists:delete(Item,List));
        false ->
          From ! {self(), not_found},
          loop(List)
      end;

    { From, {list} } ->
      From ! { self(), List },
      loop(List);

    terminate ->
      ok
  end.
