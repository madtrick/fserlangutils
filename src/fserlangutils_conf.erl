-module(fserlangutils_conf).

-export([read/1, read/2, read2/1, read2/2]).

% DEPRECATED
-spec read(Filepath :: string()) -> term().
read(Filepath) ->
  io:format("fserlangutils_conf:read/1 is deprecated please update ~n"),
  {ok, [Config]} = file:consult(
    fserlangutils_filename:relative_path(Filepath)
  ),
  {ok, Config}.

read2(Filepath) ->
  {ok, [Config]} = file:consult(Filepath),
  {ok, Config}.

% DEPRECATED
-spec read(Filepath :: string(), ExecutionMode :: atom()) -> term().
read(FilePath, ExecutionMode) ->
  io:format("fserlangutils_conf:read/2 is deprecated please update ~n"),
  {ok, Conf} = read(FilePath),
  {ok, proplists:get_value(ExecutionMode, Conf)}.

read2(FilePath, ExecutionMode) ->
  {ok, Conf} = read2(FilePath),
  {ok, proplists:get_value(ExecutionMode, Conf)}.
