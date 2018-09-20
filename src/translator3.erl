% translate module to work with gen_server
-module(translator3).
-author("arielmirra").
-behavior(gen_server).
-compile(export_all).

-type word() :: string().
-spec translate(word()) -> word().

%% API
translate(Word) ->
  gen_server:call(translator3, { translate, Word }).

% registra el actor en local/global, y despues pasas Module, Args, Options
start_link() ->
  gen_server:start_link({local, translator3}, translator3, [], []).

init(_Args) -> {ok, []}.

% handle(Request          ,   State)
handle_call({translate, "hola"}, _From,  History) ->
  {reply, "hello", ["hola" | History]};

handle_call({translate, "mundo"}, _From, History) ->
  {reply, "world", ["mundo" | History]};

handle_call({translate, W}, _From, History) ->
  {reply, "???", [W | History]};

handle_call({stats}, _From, History) ->
  {reply, History, History}.

% no produce una respuesta
handle_cast({reset}, _History) ->
  {noreply, []}.

% método llamado por el gen_server cuando hace el code_swap,
% para dejarte hacer algo con el anterior si querés
code_change(_Old, State, _Extra) ->
  {ok, State}.

terminate(_Reason, _State) ->
  ok.