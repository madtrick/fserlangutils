-module(fserlangutils_string).

-export([ensure_binary/1, ensure_list/1, to_integer/1]).

-spec ensure_binary(Data :: list()) -> binary();
                  (Data:: atom())-> binary();
                  (Data:: binary())-> binary().
ensure_binary(Data) when is_binary(Data) -> Data;
ensure_binary(Data) when is_list(Data) -> list_to_binary(Data);
ensure_binary(Data) when is_atom(Data) -> atom_to_binary(Data, utf8).

-spec ensure_list(Data :: list()) -> list();
                  (Data :: atom()) -> list();
                  (Data :: binary()) -> list().
ensure_list(Data) when is_list(Data) -> Data;
ensure_list(Data) when is_atom(Data) -> atom_to_list(Data);
ensure_list(Data) when is_binary(Data) -> binary_to_list(Data).

-spec to_integer(String :: list()) -> integer().
to_integer(String) ->
  {Integer, _} = string:to_integer(String),
  Integer.
