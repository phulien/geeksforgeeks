-module(solution).
-export([main/0]).
-include_lib("eunit/include/eunit.hrl").

%% Kth smallest element
%% https://practice.geeksforgeeks.org/problems/kth-smallest-element/0
main() ->
    {ok, [NoTest]} = io:fread("", "~d"),
    Tests = get_test(NoTest),
    lists:foreach(
      fun(Result) ->
              io:format("~p~n", [Result])
      end, [find_kth(Test) || Test <- Tests]).

get_test(NoTest) ->
    get_test(NoTest, []).

get_test(0, Res) ->
    lists:reverse(Res);
get_test(NoTest, Acc) ->
    {ok, [ArraySize]} = io:fread("", "~d"),
    Format = lists:flatten(lists:duplicate(ArraySize, "~d")),
    {ok, Array} = io:fread("", Format),
    {ok, [K]} = io:fread("", "~d"),
    get_test(NoTest - 1, [{K, Array} | Acc]).

find_kth({K, Array}) ->
    find_kth(K, Array).

find_kth(K, [Head | Tail]) ->
    Left = [Elem || Elem <- Tail, Elem < Head],
    LenLeft = length(Left),
    if LenLeft < K - 1 ->
            Right = [Elem || Elem <- Tail, Elem > Head],
            find_kth(K - LenLeft - 1, Right);
       LenLeft == K - 1 ->
            Head;
       LenLeft > K - 1 ->
            find_kth(K, Left)
    end.

simple_test() ->
    ?assert(find_kth(3, [7, 10, 4, 3, 20, 15]) =:= 7),
    ?assert(find_kth(4, [7, 10, 4, 20, 15]) =:= 15),
    ?assert(find_kth(17, [313, 885, 39, 951, 103, 713, 256, 34, 745, 360, 466,
                          262, 414, 546, 28, 409, 482, 857, 431, 25, 892, 397,
                          950, 135, 662, 981, 430, 44, 145, 897, 345]) =:= 430).
