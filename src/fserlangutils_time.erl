-module(fserlangutils_time).

-export([seconds_since_epoch/0, microseconds_since_epoch/0]).

seconds_since_epoch() ->
  {Megasecs, Secs, _Microsecs} = erlang:now(),
  megaseconds_to_seconds(Megasecs) + Secs.

microseconds_since_epoch() ->
  {Megasecs, Secs, Microsecs}  = erlang:now(),
  megaseconds_to_seconds(Megasecs) + seconds_to_microseconds(Secs) + Microsecs.

megaseconds_to_seconds(Megasecs) ->
  Megasecs * 1000000.

seconds_to_microseconds(Seconds) ->
  Seconds * 1000000.
