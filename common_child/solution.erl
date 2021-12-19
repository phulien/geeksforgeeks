-module(solution).
-export([main/0]).
-include_lib("eunit/include/eunit.hrl").

%% Common Child
%% https://www.hackerrank.com/challenges/common-child/problem
main() ->
    {ok, [StringA]} = io:fread("", "~s"),
    {ok, [StringB]} = io:fread("", "~s"),
    Res = common_child(StringA, StringB),
    io:format("~p~n", [Res]).

common_child(StringA, StringB) ->
    common_child(StringA, StringB, 0).

common_child([], _, Max) ->
    Max;
common_child(_, [], Max) ->
    Max;
common_child([Same | TailA], [Same | TailB], Max) ->
    Max + common_child(TailA, TailB) + 1;
common_child([_ | TailA] = StringA, [_ | TailB] = StringB, Max) ->
    case get({StringA, StringB}) of
        undefined ->
            Max1 = common_child(StringA, TailB),
            Max2 = common_child(TailA, StringB),
            Max3 = if Max1 > Max2 -> Max1;
                      true -> Max2
                   end,
            put({StringA, StringB}, Max3),
            Max + Max3;
        Max1 ->
            Max + Max1
    end.

%% -----------------------------------------------------------------------------
%% Tests
simple_test() ->
    ?assert(common_child("ABCD", "ABDC") =:= 3),
    ?assert(common_child("HARRY", "SALLY") =:= 2),
    ?assert(common_child("AA", "BB") =:= 0),
    ?assert(common_child("SHINCHAN", "NOHARAAA") =:= 3).
