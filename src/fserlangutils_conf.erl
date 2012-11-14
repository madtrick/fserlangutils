-module(fserlangutils_conf).

-export([read/1, read/2]).

-spec read(Filepath :: string()) -> term().
read(Filepath) ->
  {ok, [Config]} = file:consult(
    filename:join([filename:absname(""), Filepath])
  ),
  {ok, Config}.

-spec read(Filepath :: string(), ExecutionMode :: atom()) -> term().
read(FilePath, ExecutionMode) ->
  {ok, Conf} = read(FilePath),
  {ok, proplists:get_value(ExecutionMode, Conf)}.
