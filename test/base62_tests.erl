-module(base62_tests).


-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  123456789 = base62:decode(base62:encode(123456789)).
