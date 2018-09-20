-module(server1).
-author("arielmirra").

%% API
-export([start/2, swap_code/2, rpc/2]).

start(Name, Module) ->
  % registra el proceso bajo el átomo Name y lo lanza
  register(Name, spawn(fun() -> loop(Name, Module, Module:init()) end)).

loop(Name, Module, State) ->
  receive

    {From, {swap_code, NewModule}} ->
      From ! { Name, ok, ack },
      loop(Name, NewModule, NewModule:upgrade(State));

    { From, Request } ->

      try Module:handle(Request, State) of
        { Response, NewState } ->  % pattern matching of the answer
          From ! { Name, ok, Response },
          loop(Name, Module, NewState)
      catch
        % ErrorType : ErrorInstance
        _: Why ->
          From ! { Name, crash, Why },
          loop(Name, Module, State)
      end

  end.

swap_code(Name, Module) ->
  rpc(Name, {swap_code, Module}).

rpc(Name, Request) ->
  Name ! { self(), Request },
  receive
    { Name, Response } -> Response;
    { Name, crash, Why } -> exit(Why)
  end.