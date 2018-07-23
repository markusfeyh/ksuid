-module(ksuid).

%% API exports
-export([generate/0, parse/1]).

-ifdef(TEST).
-export([get_bytes/0]).
-endif.

-define(EPOCH, 1400000000).
-define(PAYLOAD_LENGTH, 16).
-define(KSUID_RAW_LENGTH, 20).
-define(KSUID_ENCODED_LENGTH, 27).
-define(PARSE_ERROR, "the value given is more than the max Ksuid value possible").
%%====================================================================
%% API functions
%%====================================================================

get_ts() ->
  Timestamp = os:system_time(second) - ?EPOCH,
  <<Timestamp:32/integer>>.

get_bytes() ->
  crypto:strong_rand_bytes(?PAYLOAD_LENGTH).

-spec generate() -> string().
generate() ->
  Timestamp = get_ts(),
  Bytes = ksuid:get_bytes(),
  <<KSUIDBin:160/integer>> = <<Timestamp/binary, Bytes/binary>>,
  KSUID62 = base62:encode(KSUIDBin),
  apply_padding(KSUID62).

-spec parse(string()) -> {ok, elrang:datetime(), binary()}.
parse(KSUID) ->
  Decoded = base62:decode(KSUID),
  <<Timestamp:32/integer, Random_Bytes/binary>> = <<Decoded:160/integer>>,
  {ok, calendar:system_time_to_local_time(Timestamp + ?EPOCH, second), Random_Bytes}.

%%====================================================================
%% Internal functions
%%====================================================================

apply_padding(KSUID62) ->
  Pad = ?KSUID_ENCODED_LENGTH - length(KSUID62),
  lists:flatten(string:pad(KSUID62, Pad, leading, 48)).