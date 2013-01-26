-module(fserlangutils_app).
-export([ensure_started/1, execution_mode/1, read_in_priv/2, read_in_dir/3]).

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
     EnvVariableName = string:concat(string:to_upper(fserlangutils_string:ensure_list(Application)), "_ENV"),
     case os:getenv(EnvVariableName) of
       false ->
         undefined;
       ExecMode ->
         AtomExecMode = list_to_atom(ExecMode),
         application:set_env(qrauth, execution_mode, AtomExecMode),
         AtomExecMode
     end
 end.

%%
%% Returns the contents of a file that's stored in the priv/ dir of an application
%%
-spec read_in_priv(Application :: atom() ,Filepath :: string()) -> term().
read_in_priv(Application, Filepath) ->
  read_in_dir(Application, priv, Filepath).


%%
%% Returns the contents of a file that's stored inside a subdir of an application
%%
-spec read_in_dir(Application :: atom(), Dir :: atom(), Filepath :: string()) -> term().
read_in_dir(Application, Dir, Filepath) ->
  case code:lib_dir(Application, Dir) of 
    {error, bad_name} ->
      RelativePath = fserlangutils_filename:relative_path(filename:join([Dir, Filepath])),
      fserlangutils_conf:read2(RelativePath);
    Path ->
      fserlangutils_conf:read2(filename:join([Path, Filepath]))
  end.


