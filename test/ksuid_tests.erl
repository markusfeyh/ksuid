-module(ksuid_tests).

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  meck:new(ksuid, [passthrough]),

  Self = self(),
  meck:expect(ksuid, get_bytes, fun() -> Result = meck:passthrough([]), Self ! {random_bytes, Result}, Result end),
  {ok, Timestamp, Random_Bytes} = ksuid:parse(ksuid:generate()),
  Expected_Random_Bytes =
    receive
      {random_bytes, Bytes} -> Bytes
    end,

  ?assertEqual(Random_Bytes, Expected_Random_Bytes),
  meck:unload().
