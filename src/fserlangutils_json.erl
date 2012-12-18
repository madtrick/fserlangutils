-module(fserlangutils_json).

-export([to/1, from/1]).
-export([to_json_structure/1, tuple_to_json_structure/1, proplist_to_json_structure/1]).

%%%%%%%%%%%%%%%%%%%%
% API
%%%%%%%%%%%%%%%%%%%%
-spec from(Input::string()) -> term().
from(Input) ->
  try jiffy:decode(Input) of
    Value -> Value
    catch
      _:{error,{_, truncated_json}} -> {error, empty_input};
      _:{error,{_, E}} -> {error, {invalid_json, E}}
    end.


-spec to(Input::term()) -> string().
to(Value) ->
  jiffy:encode(Value).


to_json_structure(Data) when is_list(Data) ->
  case lists:all(fun({_,_}) -> true ; (_) -> false end, Data) of
    true -> proplist_to_json_structure(Data);
    false -> Data
  end;
to_json_structure(Data) when is_tuple(Data)->
  tuple_to_json_structure(Data);
to_json_structure(Data) ->
  Data.

tuple_to_json_structure({}) ->
  {[]};
tuple_to_json_structure({Field, Value}) ->
  {[{Field, to_json_structure(Value)}]}.

proplist_to_json_structure(Proplist) ->
  {
    lists:foldr(fun({Key, Value}, Acc) ->
          [{Key, to_json_structure(Value)} | Acc]
      end, [], Proplist )
  }.
