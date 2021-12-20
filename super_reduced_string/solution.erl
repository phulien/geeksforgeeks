-module(solution).
-export([main/0]).
-include_lib("eunit/include/eunit.hrl").

%% Super Reduced String
%% https://www.hackerrank.com/challenges/reduced-string/problem
main() ->
    {ok, [String]} = io:fread("", "~s"),
    Res = reduce(String),
    io:format("~s~n", [Res]).

reduce(String) ->
    reduce(String, "", false).

reduce([Same, Same | Rest], Acc, _Loop) ->
    reduce(Rest, Acc, true);
reduce([Char | Res], Acc, Loop) ->
    reduce(Res, [Char | Acc], Loop);
reduce([], Acc, true) ->
    reduce(lists:reverse(Acc), "", false);
reduce([], "", false) ->
    "Empty String";
reduce([], Res, false) ->
    lists:reverse(Res).

%% -----------------------------------------------------------------------------
%% Tests
simple_test() ->
    ?assert(reduce("aab") =:= "b"),
    ?assert(reduce("abba") =:= "Empty String"),
    ?assert(reduce("aaabccddd") =:= "abd"),
    ?assert(reduce("aa") =:= "Empty String"),
    ?assert(reduce("baab") =:= "Empty String").
