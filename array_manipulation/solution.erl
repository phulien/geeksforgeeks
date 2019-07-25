-module(solution).
-export([main/0]).
-include_lib("eunit/include/eunit.hrl").

%% Array Manipulation
%% https://www.hackerrank.com/challenges/crush/problem
main() ->
    {ok, [_ArraySize, LoopNumber]} = io:fread("", "~d ~d"),
    Format = lists:flatten(lists:duplicate(LoopNumber, "~d~d~d")),
    {ok, Ops} = io:fread("", Format),
    io:format("~p~n", [loop(Ops)]).

loop(Ops) ->
    loop(Ops, maps:new()).

loop([A, B, K | Tail], Map) ->
    NewMap = update_map(Map, A, B + 1, K),
    loop(Tail, NewMap);
loop([], Map) ->
    get_max(Map).

update_map(Map, A, Bplus, K) ->
    NewMap = put_map(A, K, Map),
    put_map(Bplus, -K, NewMap).

put_map(Key, Value, Map) ->
    case maps:get(Key, Map, undefined) of
        undefined ->
            maps:put(Key, Value, Map);
        OldValue ->
            maps:update(Key, OldValue + Value, Map)
    end.

get_max(Map) ->
    Keys = lists:sort(maps:keys(Map)),
    get_max(Keys, Map, 0, 0).
get_max([Key | Keys], Map, Acc, Max) ->
    NewAcc = Acc +  maps:get(Key, Map),
    NewMax = max(NewAcc, Max),
    get_max(Keys, Map, NewAcc, NewMax);
get_max([], _Map, _Acc, Max) ->
    Max.

%% -----------------------------------------------------------------------------
%% Tests
simple_test() ->
    ?assert(loop([1,5,3,4,8,7,6,9,1]) =:= 10),
    ?assert(loop([1,2,100,2,5,100,3,4,100]) =:= 200),
    ?assert(loop([2,6,8,3,5,7,1,8,1,5,9,15]) =:= 31).


