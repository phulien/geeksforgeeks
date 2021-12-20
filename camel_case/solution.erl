-module(solution).
-export([main/0]).
-include_lib("eunit/include/eunit.hrl").

%% CamelCase
%% https://www.hackerrank.com/challenges/camelcase/problem
main() ->
    {ok, [String]} = io:fread("", "~s"),
    Res = count(String),
    io:format("~p~n", [Res]).

count(String) ->
    count(String, 0).

count([], Res) ->
    Res + 1;
count([Char | Rest], Num) when Char >= $A andalso Char =< $Z ->
    count(Rest, Num + 1);
count([_Char | Rest], Num) ->
    count(Rest, Num).

%% -----------------------------------------------------------------------------
%% Tests
simple_test() ->
    ?assert(count("oneTwoThree") =:= 3),
    ?assert(count("saveChangesInTheEditor") =:= 5).
