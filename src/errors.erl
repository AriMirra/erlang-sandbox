-module(errors).
-author("arielmirra").
-compile(export_all).


%% recibe un proceso y una función
%% crea un actor, en el caso que se produzca un exit, atrapalo
%% link monitorea un actor, si uno muere, el otro también
%% al hacer el link, recibo el exit del otro proceso (actor) como un mensaje
%% al recibir el EXIT, llama a la función que me pasaron como parámetro
on_exit(Pid, Fun) ->
  spawn(fun() ->
    process_flag(trap_exit, true),
    link(Pid),
    receive
      { 'EXIT', Pid, Why } -> Fun(Why)
    end
  end).

% keep_alive
% recibe nombre de proceso y funcion
% lanza un proceso y lo mantiene siempre vivo
% register: un mapa mutable
% en el on_exit, llama a keep_alive denuevo, crea otro proceso de reemplazo
% registra el PID del proceso creado, bajo el mismo nombre, para que se
% pueda seguir usando.
keep_alive(Name, F) ->
  register(Name, Pid = spawn(F)),
  on_exit(Pid, fun(_Why) -> keep_alive(Name, F) end).