-module(fserlangutils_time).

-export([seconds_since_epoch/0]).

seconds_since_epoch() ->
  {Megasecs, Secs, _Microsecs} = now(),
  (Megasecs* 1000) + Secs .
