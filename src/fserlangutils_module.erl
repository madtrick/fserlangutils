-module(fserlangutils_module).

-export([attribute/2]).

-spec attribute(Module :: atom(), Attribute :: atom()) -> term() | undefined.
attribute(Module, Attribute) ->
  Attributes = Module:module_info(attributes),
  proplists:get_value(Attribute, Attributes).
