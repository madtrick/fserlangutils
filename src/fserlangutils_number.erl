-module(fserlangutils_number).

-export([floor/1, ceil/1]).

%
% Floor and Ceil functions extracted from http://schemecookbook.org/Erlang/NumberRounding
%
-spec floor(Number :: float()) -> integer();
          (Number :: integer()) -> integer().
floor(Number) when is_integer(Number) ->
  Number;
floor(Number) when is_float(Number) ->
  T = erlang:trunc(Number),
  case (Number - T) of
    Neg when Neg < 0 -> T - 1;
    Pos when Pos > 0 -> T;
    _ -> T
  end.

-spec ceil(Number :: float()) -> integer();
          (Number :: integer()) -> integer().
ceil(Number) ->
  T = erlang:trunc(Number),
  case (Number - T) of
    Neg when Neg < 0 -> T;
    Pos when Pos > 0 -> T + 1;
    _ -> T
  end.

