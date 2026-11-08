ksuid
=====

Allows for the generation of KSUIDs in erlang

Based on the elixir implementation:
https://github.com/girishramnani/elixir-ksuid

Usage
-----

    1> ksuid:generate().
    "3LoWT4pnsrBTKrUSLJXJE2w7ku1"
    2> ksuid:parse("0ujtsYcgvSTl8PAuAdqWYSMnLOv").
    {ok,{{2017,10,10},{4,0,47}},
        <<181,161,205,52,181,249,157,17,84,251,104,83,52,92,151,53>>}

`parse/1` returns the timestamp as a UTC `calendar:datetime()` and the
16-byte random payload.

Build
-----

Tested with Erlang/OTP 29 and rebar3 3.28 (CI also runs OTP 27 and 28).

    $ rebar3 compile
    $ rebar3 eunit
    $ rebar3 xref
    $ rebar3 dialyzer
