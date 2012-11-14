-module(fserlangutils_app).
-export([ensure_started/1, execution_mode/1]).

%%
%% Ensures that an application is started
-spec ensure_started(AppName :: atom()) -> ok.
ensure_started(AppName) ->
  case application:start(AppName) of
      ok ->
        ok;
      {error, {already_started, AppName}} ->
        ok;
      {error, {not_started, Dep}} ->
        ensure_started(Dep),
        ensure_started(AppName);
      {error, {shutdown, _}} ->
        error
    end.

%%
%% Returns the current execution mode,
%% It'll first look into the application environment.
%% If it's not there it'll try with the OS environment.
%%
-spec execution_mode(Application :: atom()) -> atom().
execution_mode(Application) ->
 case application:get_env(Application, execution_mode) of
   {ok, ExecMode} ->  ExecMode;
   undefined ->
     EnvVariableName = string:concat(erlang:to_upper(Application), "_ENV"),
     case os:getenv(EnvVariableName) of
       false ->
         undefined;
       ExecMode ->
         AtomExecMode = list_to_atom(ExecMode),
         application:set_env(qrauth, execution_mode, AtomExecMode),
         AtomExecMode
     end
 end.
