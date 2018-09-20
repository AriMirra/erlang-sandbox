% translate module to work with server1
-module(translate2).
-author("arielmirra").

%% API
-compile(export_all).

init() -> [].

% handle(Request          ,   State)
handle({translate, "hola"}, History) ->
  {"hello", ["hola" | History]};

handle({translate, "mundo"}, History) ->
  {"world", ["mundo" | History]};

handle({translate, W}, History) ->
  {"???", [W | History]};

handle({stats}, History) ->
  {History, History};

handle({reset}, History) ->
  {History,[]}.

upgrade(State) ->
  State.