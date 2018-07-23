-module(base62).
-export([encode/1, decode/1]).

nthchar(N) when N =< 9 -> $0 + N;
nthchar(N) when N =< 35 -> $A + N - 10;
nthchar(N) -> $a + N - 36.

-spec encode(integer()) -> string().
encode(X) ->
  encode_int(X).

encode_int(Id) -> encode_int(Id, []).

encode_int(Id, Acc) when Id < 0 -> encode_int(-Id, Acc);
encode_int(Id, []) when Id =:= 0 -> "0";
encode_int(Id, Acc) when Id =:= 0 -> Acc;
encode_int(Id, Acc) ->
  R = Id rem 62,
  Id1 = Id div 62,
  Ac1 = [nthchar(R) | Acc],
  encode_int(Id1, Ac1).

-spec decode(string()) -> integer().
decode(S) -> decode(S, 0).
decode([C | Cs], Acc) when C >= $0, C =< $9 -> decode(Cs, 62 * Acc + (C - $0));
decode([C | Cs], Acc) when C >= $A, C =< $Z -> decode(Cs, 62 * Acc + (C - $A + 10));
decode([C | Cs], Acc) when C >= $a, C =< $z -> decode(Cs, 62 * Acc + (C - $a + 36));
decode([], Acc) -> Acc.