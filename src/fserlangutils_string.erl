-module(fserlangutils_string).

-export([ensure_binary/1]).

-spec ensure_binary(Data :: list()) -> binary();
                  (Data:: binary())-> binary().
ensure_binary(Data) when is_binary(Data) -> Data;
ensure_binary(Data) when is_list(Data) -> list_to_binary(Data).

