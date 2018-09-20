-module(translate).
-author("arielmirra").

%% API
-export([loop/0]).

loop() -> loop([]).

loop(History) ->
    receive
      { From, {translate, "hola"} } ->
          From ! {ok, "hello"},
          loop(["hola" | History]);

      { From, {translate, "mundo"} } ->
        From ! {ok, "world"},
        loop(["mundo" | History]);

      { From, {stats} } ->
          From ! { ok, History },
          loop(History);

      { From, {reset} } ->
          From ! {ok, History},
          loop([]);

      { From, _ } ->
        From ! "???",
        loop(History)
    end.

