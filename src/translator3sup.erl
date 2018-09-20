-module(translator3sup).
-author("arielmirra").
-behavior(supervisor).
%% API
-export([start_link/0, init/1]).


start_link() ->
  supervisor:start_link(translator3sup, []).

init(_Args) ->
  SupFlags = #{
    strategy => one_for_one, intensity => 1, period => 5
  },
  ChildSpecs = [
    #{id => translator3,
      start => {translator3, start_link, []},
      restart => permanent, % permanent, transient or temporal
      shutdown => brutal_kill,
      type => worker, % worker / supervisor
      modules => [translator3]
    }
  ],
  {ok, SupFlags, ChildSpecs}.