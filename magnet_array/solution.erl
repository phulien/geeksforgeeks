-module(solution).
-export([main/0]).
-include_lib("eunit/include/eunit.hrl").

%% Magnet Array Problem
%% https://practice.geeksforgeeks.org/problems/magnet-array-problem/0
main() ->
    {ok, [NoTest]} = io:fread("", "~d"),
    Tests = get_test(NoTest),
    lists:foreach(
      fun(Result) ->
              io:format("~p~n", [Result])
      end, [find_point(Test) || Test <- Tests]).

get_test(NoTest) ->
    get_test(NoTest, []).

get_test(0, Res) ->
    lists:reverse(Res);
get_test(NoTest, Acc) ->
    {ok, [ArraySize]} = io:fread("", "~d"),
    Format = lists:flatten(lists:duplicate(ArraySize, "~d")),
    {ok, Array} = io:fread("", Format),
    get_test(NoTest - 1, [Array | Acc]).

find_point(Array) ->
    find_point(Array, [], []).

find_point([First, Second | Tail], AccLeft, Acc) ->
    Left = AccLeft ++ [First],
    Right = [Second | Tail],
    Middle = (First + Second) / 2,
    Res = binary_search(Left, First, Middle, Second, Right),
    find_point(Right, Left, [Res | Acc]);
find_point([_Last], _AccLeft, Res) ->
    lists:reverse(Res).

binary_search(Left, LeftPoint, Middle, RightPoint, Right) ->
    SubForce = force(Left, Middle) - force(Right, Middle),
    if abs(SubForce) =< 0.0000000000001 ->
            round(Middle, 2);
       SubForce > 0 ->
            %% Left is stronger, zero net force shall in the right
            NewMiddle = (Middle + RightPoint) / 2,
            binary_search(Left, Middle, NewMiddle, RightPoint, Right);
       SubForce < 0 ->
            %% Right is stronger, zero net force shall in the left
            NewMiddle = (LeftPoint + Middle) / 2,
            binary_search(Left, LeftPoint, NewMiddle, Middle, Right)
    end.

force(Magnets, Point) ->
    lists:foldl(
      fun(Magnet, Acc) ->
              1/abs(Point - Magnet) + Acc
      end, 0, Magnets).

round(Number, Precision) ->
    P = math:pow(10, Precision),
    round(Number * P) / P.

%% -----------------------------------------------------------------------------
%% Tests
simple_test() ->
    ?assert(find_point([1, 2]) =:= [1.5]),
    ?assert(find_point([0, 10, 20, 30]) =:= [3.82, 15.0, 26.18]).
