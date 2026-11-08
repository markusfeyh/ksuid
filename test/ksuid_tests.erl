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

  ?assertEqual(Expected_Random_Bytes, Random_Bytes),
  Now = calendar:datetime_to_gregorian_seconds(calendar:universal_time()),
  ?assert(abs(Now - calendar:datetime_to_gregorian_seconds(Timestamp)) =< 2),
  meck:unload().

%% Reference value from https://github.com/segmentio/ksuid#inspect-the-components-of-a-ksuid
%% (Time: 2017-10-09 21:00:47 -0700 PDT, i.e. 2017-10-10 04:00:47 UTC).
parse_reference_test() ->
  ?assertEqual({ok, {{2017, 10, 10}, {4, 0, 47}}, <<16#B5A1CD34B5F99D1154FB6853345C9735:128>>},
               ksuid:parse("0ujtsYcgvSTl8PAuAdqWYSMnLOv")).
