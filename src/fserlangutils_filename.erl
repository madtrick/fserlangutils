-module(fserlangutils_filename).

-export([relative_path/1]).

% Pass a path relative to application root
% Returns: a full path
relative_path(Path) ->
    {ok, Cwd} = file:get_cwd(),
    filename:join([Cwd, Path]).
