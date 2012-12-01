-module(fserlangutils_filename).

-export([relative_path/1]).

% Pass a path relative to application root
% Returns: a full path
relative_path(Path) ->
    filename:join([filename:absname(""), Path]).
