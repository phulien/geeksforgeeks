-module(solution).
-export([main/0]).
-include_lib("eunit/include/eunit.hrl").

%% Relative Sorting
%% https://practice.geeksforgeeks.org/problems/relative-sorting/0
main() ->
    {ok, [NoTest]} = io:fread("", "~d"),
    Tests = get_test(NoTest),
    lists:foreach(
      fun(Result) ->
              io:format("~p~n", [Result])
      end, [relative_sort(Test) || Test <- Tests]).

get_test(NoTest) ->
    get_test(NoTest, []).

get_test(0, Res) ->
    lists:reverse(Res);
get_test(NoTest, Acc) ->
    {ok, [A1Size, A2Size]} = io:fread("", "~d~d"),
    FormatA1 = lists:flatten(lists:duplicate(A1Size, "~d")),
    FormatA2 = lists:flatten(lists:duplicate(A2Size, "~d")),
    {ok, A1} = io:fread("", FormatA1),
    {ok, A2} = io:fread("", FormatA2),
    get_test(NoTest - 1, [{A1, A2} | Acc]).

relative_sort({A1, A2}) ->
    Map = lists:foldl(
            fun(Number, AccMap) ->
                    case maps:take(Number, AccMap) of
                        error ->
                            maps:put(Number, 1, AccMap);
                        {Value, NewMap} ->
                            maps:put(Number, Value + 1, NewMap)
                    end
            end, maps:new(), A1),
    {SortedList, RestMap} =
        lists:foldl(
          fun(Number, {AccList, AccMap}) ->
                  case maps:take(Number, AccMap) of
                      error ->
                          {AccList, AccMap};
                      {Value, NewMap} ->
                          {add_to_list(Value, Number, AccList), NewMap}
                  end
          end, {[], Map}, A2),
    Res = lists:foldl(
            fun(Key, Acc) ->
                    Value = maps:get(Key, RestMap),
                    add_to_list(Value, Key, Acc)
            end, SortedList, lists:sort(maps:keys(RestMap))),
    lists:reverse(Res).

add_to_list(0, _Number, Res) ->
    Res;
add_to_list(Value, Number, List) ->
    add_to_list(Value - 1, Number, [Number | List]).

%% -----------------------------------------------------------------------------
%% Tests
simple_test() ->
    ?assert(relative_sort({[2,1,2,5,7,1,9,3,6,8,8],
                           [2,1,8,3]}) =:= [2,2,1,1,8,8,3,5,6,7,9]),
    ?assert(relative_sort({[2,2,5,7,9,3,6],
                           [2,1,8,3]}) =:= [2,2,3,5,6,7,9]),
    ?assert(relative_sort({[15,47,59,326,124,5,623,128,483,153,125,232,154,555,
                            656,485,659,32,125,326,324,96,565,154,112,32,85,563,
                            32,481,32],
                           [20,47,20,5,125,154,555,32,324]}) =:=
                [47,5,125,125,154,154,555,32,32,32,32,324,15,59,85,96,112,124,128,153,
                 232,326,326,481,483,485,563,565,623,656,659]).

